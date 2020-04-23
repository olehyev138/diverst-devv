variable "nat_gateway_enabled" {
  type        = bool
  description = "Boolean indicating whether NAT Gateway is enabled or not, if false we use nat instance"
}

variable "az_count" {
  type        = number
  description = "Number of availability zones"
}

variable "ssh_key_name" {
  type        = string
  description = "Type of NAT to use: gateway or instance"
}
