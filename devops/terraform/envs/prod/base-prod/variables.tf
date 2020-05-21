variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "az_count" {
  type        = number
  description = "Number of availability zones"
}

variable "nat_gateway_enabled" {
  type        = bool
  description = "Whether NAT Gateways are enabled or not"
}

variable "ssh_key_name" {
  type = string
}

# Backend
variable "backend_solution_stack" {
  type    = string
}

variable "rails_master_key" {
  type    = string
}

variable "backend_asg_min" {
  type    = number
}

variable "backend_asg_max" {
  type    = number
}

variable "backend_ec2_type" {
  type    = string
}

variable "sidekiq_username" {
  type    = string
}

variable "sidekiq_password" {
  type    = string
}

# Database
variable "db_class" {
  type    = string
}

variable "multi_az" {
  type    = bool
}

variable "db_allocated_storage" {
  type    = string
}

variable "db_backup_retention" {
  type    = number
}

variable "db_backup_window" {
  type    = string
}

variable "db_deletion_protection" {
  type    = bool
}

variable "db_apply_immediately" {
  type    = bool
}

variable "db_maintenance_window" {
  type    = string
}

variable "db_name" {
  type    = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "analytics_interval" {
  type = string
}

#
## 3rd party services
#

variable "rollbar_env" {
  type = string
}

variable "rollbar_access_token" {
  type = string
}

variable "mailgun_domain" {
  type = string
}

variable "mailgun_api_key" {
  type = string
}

variable "embedly_key" {
  type = string
}
