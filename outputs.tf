output "az_subnet_ids" {
  # value = azurerm_subnet.az_subnet["private_subnet"].id
  # value = toset([for subid in azurerm_subnet.az_subnet : subid.id])
  # value = tomap({
  #   for k, azsub in azurerm_subnet.az_subnet : k => azsub.id
  # })
  value = [for s in azurerm_subnet.az_subnet : s.id]
}

output "az_nsg_ids" {
  # value = azurerm_network_security_group.az_nsg["private_subnet"].id
  value = [for nsg in azurerm_network_security_group.az_nsg : nsg.id]

}
