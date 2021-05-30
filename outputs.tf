output "az_vnic_ids" {
  #value = toset([for vnicid in azurerm_network_interface.az_vnic : vnicid.id])
  value = toset([for vnicid in azurerm_network_interface.az_vnic : vnicid.id])
}