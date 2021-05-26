variable "rg_name" {
  default = ""
}

variable "rg_location" {
  default = ""
}

variable "name" {
  default = ""
}
#Lab
variable "address_space" {
  default = ""
}
# "10.0.0.0/16"
variable "subnet_name_suffix" {
  default = ""
}
# internal
variable "address_prefixes" {
  default = []
}
# "10.0.1.0/24"
variable "public_ip_suffix" {
  default = ""
}
# public
variable "network_interface_suffix" {
  default = ""
}
# nic