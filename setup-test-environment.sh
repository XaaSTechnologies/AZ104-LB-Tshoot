

# POINT HEALTH PROBE AT PORT 1234 IN BACKEND POOL

az network lb probe update \
  --resource-group RG-11-LB \
  --lb-name LB-TSHOOT \
  --name HEALTHPROBE-80-LB-TSHOOT \
  --protocol Tcp \
  --port 1234

# STOP VM-02

az vm stop \
  --resource-group RG-11-LB \
  --name VM-02

# DELETE NSG RULE FOR SUBNET-01 THAT ALLOWS PORT 80
az network nsg rule delete \
  --resource-group RG-11-LB \
  --name AZ104-vNET-NSG-RULE \
  --nsg-name NSG-LB-LAB

# SET NSG FOR VM-02 WITH DENY ALL
az network nsg rule create \
  --resource-group RG-11-LB \
  --name AZ104-vNET-NSG-VM-02-DENY-ALL \
  --nsg-name NSG-VM-02 \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix '*' \
  --destination-port-range '*' \
  --access deny \
  --priority 150

