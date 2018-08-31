variable "name" {}
variable "key_name" {}
variable "instance_type" {
  default = "t3.small"
}
variable "worker_instance_type" {
  default = "t3.small"
}

variable "worker_on_the_same_instance" {
  default = false
}

variable "volume_size" {
  default = 20
}

variable "webservers_count" {
  default = 1
}
variable "workers_count" {
  default = 0
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}

variable "default_security_group" {}
variable "webserver_security_group" {}
