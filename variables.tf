variable "resource_group_name" {
  description = "Resource group name"
  default     = ""
}

variable "location" {
  description = "Location name"
  default     = ""
}

variable "address_space" {
  description = "Address space"
  default     = ""
}

variable "name" {
  description = "Virtual netwoork name"
  default     = ""
}

variable "subnets" {
  default = {}
}
