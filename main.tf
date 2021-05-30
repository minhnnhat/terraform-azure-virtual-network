provider "azurerm" {
  features {}
}
#----------------
# Resource group
#----------------
locals {
  # resource_group_name = element(coalescelist(data.azurerm_resource_group.az_drg.*.name, azurerm_resource_group.az_rg.*.name, [""]), 0)
  # location            = element(coalescelist(data.azurerm_resource_group.az_drg.*.location, azurerm_resource_group.az_rg.*.location, [""]), 0)
  resource_group_name = var.resource_group_name
  location = var.location
  if_ddos_enabled     = var.create_ddos_plan ? [{}] : []
  subnet_ids           = tomap({for k, sub in azurerm_subnet.az_subnet : k => sub.id})
}

# data "azurerm_resource_group" "az_drg" {
#   count    = var.create_resource_group == false ? 1 : 0
#   name     = var.resource_group_name
# }

# resource "azurerm_resource_group" "az_rg" {
#   count    = var.create_resource_group ? 1 : 0
#   name     = var.resource_group_name
#   location = var.location
# }
#-----------------
# Create virtual network - Default "true"
#-----------------
resource "azurerm_virtual_network" "az_vnet" {
  resource_group_name = local.resource_group_name
  location            = local.location

  name                = var.name

  address_space       = var.address_space
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = local.if_ddos_enabled

    content {
      id     = azurerm_network_ddos_protection_plan.az_ddos[0].id
      enable = true
    }
  }
}
#-----------
# Create DDos plan - Default "false"
#-----------
resource "azurerm_network_ddos_protection_plan" "az_ddos" {
  resource_group_name = local.resource_group_name
  location            = local.location

  count               = var.create_ddos_plan ? 1 : 0
  name                = var.ddos_plan_name
}

resource "azurerm_subnet" "az_subnet" {
  resource_group_name                            = local.resource_group_name

  for_each                                       = var.subnets
  name                                           = each.value.subnet_name
  virtual_network_name                           = azurerm_virtual_network.az_vnet.name
  address_prefixes                               = each.value.subnet_address_prefix
  service_endpoints                              = lookup(each.value, "service_endpoints", [])
}

resource "azurerm_network_interface" "az_vnic" {
  resource_group_name = local.resource_group_name
  location            = local.location

  for_each                   = local.subnet_ids
  name = format("%s-${each.key}", var.vnic_name)

  ip_configuration {
    name                          = format("%s-${each.key}", var.ipconfig_name)
    subnet_id                     = each.value
    private_ip_address_allocation = "Dynamic"
  }
}