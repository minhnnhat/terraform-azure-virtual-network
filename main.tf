resource "azurerm_virtual_network" "az_vnet" {    
    location            = var.rg_location
    resource_group_name = var.rg_name

    name                = var.name
    address_space       = [var.address_space]
}

resource "azurerm_subnet" "az_vnet_subnet" {
    resource_group_name     = var.rg_name

    name                    = "${format("%s-${var.subnet_name_suffix}", var.name)}"

    virtual_network_name    = azurerm_virtual_network.az_vnet.name
    address_prefixes        = [var.address_prefixes]
}

resource "azurerm_public_ip" "az_vnet_pip" {
    location            = var.rg_location
    resource_group_name = var.rg_name

    name                = "${format("%s-${var.public_ip_suffix}", var.name)}"
    allocation_method   = "Dynamic"

}

resource "azurerm_network_interface" "az_vnet_interface" {
    location            = var.rg_location
    resource_group_name = var.rg_name

    name                = "${format("%s-${var.network_interface_suffix}", var.name)}"

    ip_configuration {
        name                            = "ipconfig1"
        subnet_id                       = azurerm_subnet.az_vnet_subnet.id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.az_vnet_pip.id
    }
}

# resource "azurerm_public_ip" "pip" {
#   count               = var.enable_public_ip_address == true ? var.instances_count : 0
#   name                = lower("pip-vm-${var.virtual_machine_name}-${var.rg_location}-0${count.index + 1}")
#   location            = var.rg_location
#   resource_group_name = var.rg_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   domain_name_label   = format("%s%s", lower(replace(var.virtual_machine_name, "/[[:^alnum:]]/", "")), random_string.str[count.index].result)
#   tags                = merge({ "ResourceName" = lower("pip-vm-${var.virtual_machine_name}-${data.azurerm_resource_group.rg.location}-0${count.index + 1}") }, var.tags, )
# }