output "az_vnic_ids" {
  #value = toset([for vnicid in azurerm_network_interface.az_vnic : vnicid.id])
  value = toset([for vnicid in azurerm_network_interface.az_vnic : vnicid.id])
}

output "az_subnet_ids" {
  value = toset([for subnetid in azurerm_subnet.az_subnet : subnetid.id])
}