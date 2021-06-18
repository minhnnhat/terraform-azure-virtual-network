#----------------
# Resource group
#----------------
locals {
  resource_group_name = var.resource_group_name
  location            = var.location
}
#------------------------
# Create virtual network
#------------------------
resource "azurerm_virtual_network" "az_vnet" {
  resource_group_name = local.resource_group_name
  location            = local.location

  name          = var.name
  address_space = var.address_space
}
#---------------
# Create subnet
#---------------
resource "azurerm_subnet" "az_subnet" {
  resource_group_name = local.resource_group_name

  for_each             = var.subnets
  name                 = each.value.subnet_name
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes     = each.value.subnet_address_prefix
  service_endpoints    = each.value.subnet_service_endpoint
}

#------------------------
# Network security group
#------------------------
resource "azurerm_network_security_group" "az_nsg" {
  resource_group_name = local.resource_group_name
  location            = local.location

  for_each = var.subnets
  name     = lower("nsg_${each.key}_in")

  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_inbound_rules", []), lookup(each.value, "nsg_outbound_rules", []))
    content {
      name                       = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                     = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                   = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range          = "*"
      destination_port_range     = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      source_address_prefix      = security_rule.value[6] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[6]
      destination_address_prefix = security_rule.value[7] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[7]
      description                = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
}