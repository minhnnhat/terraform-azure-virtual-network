variable "create_resource_group" {
  description = "Whether create resource group - Default is false"
  default     = false
}

variable "create_ddos_plan" {
  description = "Create an ddos plan - Default is false"
  default     = false
}

variable "resource_group_name" {
  description = "Resource group name"
  default     = ""
}

variable "location" {
  description = "Location name"
  default     = ""
}

variable "name" {
  description = "Virtual network name"
  default = ""
}

variable "address_space" {
  description = "Address space used in virtual update"
  default = []
}

variable "subnets" {
  description = "For each subnet, create an object that contain fields"
  type = map(any)
}

variable "ddos_plan_name" {
  description = "DDoS Protection Plan name"
  default     = ""
}

variable "dns_servers" {
  description = "List of dns servers to use for virtual network"
  default     = []
}

variable "vnic_name" {
  description = "Network interface name"
  default     = ""
}

variable "ipconfig_name" {
  description = "Ip configuration name"
  default     = ""
}