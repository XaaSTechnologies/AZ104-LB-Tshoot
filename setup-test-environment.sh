# Script to create the Testing Environment

az group create \
--name RG-11-LB \
--location westeurope

az network vnet create \
  --resource-group RG-11-LB \
  --name AZ104-vNET \
  --subnet-name SUBNET-01

az network nsg create \
  --resource-group RG-11-LB \
  --name NSG-LB-LAB

az network nsg rule create \
  --resource-group RG-11-LB \
  --name AZ104-vNET-NSG-RULE \
  --nsg-name NSG-LB-LAB \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 80 \
  --access allow \
  --priority 200

az network nsg rule create \
  --resource-group RG-11-LB \
  --name AZ104-vNET-SSH-RULE \
  --nsg-name NSG-LB-LAB \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range 22 \
  --access allow \
  --priority 300

az network vnet subnet update \
  --resource-group RG-11-LB \
  --vnet-name AZ104-vNET \
  --name SUBNET-01 \
  --network-security-group NSG-LB-LAB

az network public-ip create \
  --resource-group RG-11-LB \
  --name PIP-01 \
  --sku Standard \
  --version IPv4

az network lb create \
  --resource-group RG-11-LB \
  --name LB-TSHOOT \
  --sku Standard \
  --public-ip-address PIP-01 \
  --public-ip-address-allocation Static \
  --frontend-ip-name FRONTEND-IP \
  --backend-pool-name BACKENDPOOL

az network lb probe create \
  --resource-group RG-11-LB \
  --lb-name LB-TSHOOT \
  --name HEALTHPROBE-80-LB-TSHOOT \
  --protocol Tcp \
  --interval 5 \
  --port 80

az network lb rule create \
  --resource-group RG-11-LB \
  --lb-name LB-TSHOOT \
  --name RULE-01-TCP-SRC-80-DST-80 \
  --protocol tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name FRONTEND-IP \
  --backend-pool-name BACKENDPOOL \
  --probe-name HEALTHPROBE-80-LB-TSHOOT

az network nsg create \
  --resource-group RG-11-LB \
  --name NSG-VM-01

az network nsg rule create \
  --resource-group RG-11-LB \
  --name AZ104-vNET-NSG-VM-01-RULE \
  --nsg-name NSG-VM-01\
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 80 \
  --access allow \
  --priority 200

az network nsg rule create \
  --resource-group RG-11-LB \
  --name AZ104-vNET-VM-01-SSH-RULE \
  --nsg-name NSG-VM-01\
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 22 \
  --access allow \
  --priority 100

az network nic create \
  --resource-group RG-11-LB \
  --name NIC-VM-01 \
  --vnet-name AZ104-vNET \
  --subnet SUBNET-01 \
  --network-security-group NSG-VM-01 \
  --lb-name LB-TSHOOT \
  --lb-address-pools BACKENDPOOL

az network nsg create \
  --resource-group RG-11-LB \
  --name NSG-VM-02

az network nsg rule create \
  --resource-group RG-11-LB \
  --name AZ104-vNET-NSG-VM-02-RULE \
  --nsg-name NSG-VM-02\
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 80 \
  --access allow \
  --priority 200

az network nsg rule create \
  --resource-group RG-11-LB \
  --name AZ104-vNET-VM-02-SSH-RULE \
  --nsg-name NSG-VM-02\
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 22 \
  --access allow \
  --priority 100

az network nic create \
  --resource-group RG-11-LB \
  --name NIC-VM-02 \
  --vnet-name AZ104-vNET \
  --subnet SUBNET-01 \
  --network-security-group NSG-VM-02 \
  --lb-name LB-TSHOOT \
  --lb-address-pools BACKENDPOOL

az vm create \
  --resource-group RG-11-LB \
  --name VM-01 \
  --nics NIC-VM-01 \
  --admin-username adminuser \
  --admin-password adminadmin123! \
  --image UbuntuLTS \
  --public-ip-address "" 

az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name VM-01 \
  --resource-group RG-11-LB \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install apache2 && echo AZ-104 Load Balancing Tshoot Lab - VM-01 > /var/www/html/index.html"}'

az vm create \
  --resource-group RG-11-LB \
  --name VM-02 \
  --nics NIC-VM-02 \
  --admin-username adminuser \
  --admin-password adminadmin123! \
  --image UbuntuLTS \
  --public-ip-address ""

az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name VM-02 \
  --resource-group RG-11-LB \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install apache2 && echo AZ-104 Load Balancing Tshoot Lab - VM-02 > /var/www/html/index.html"}'

az vm create \
  --resource-group RG-11-LB \
  --name JUMPSTATION \
  --admin-username adminuser \
  --admin-password adminadmin123! \
  --image UbuntuLTS \
  --vnet-name AZ104-vNET \
  --subnet SUBNET-01 \
  --public-ip-address-allocation static
