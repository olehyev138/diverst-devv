variable "env_name" {}
variable "vpc_id"   {}

variable "asg_min"    {}
variable "asg_max"    {}
variable "ec2_type"   {}

variable "sn_elb" {}
variable "sg_elb" {}

variable "sn_app" {}
variable "sg_app" {}

variable "sidekiq_username" {}
variable "sidekiq_password" {}

variable "db_address"   {}
variable "db_username"  {}
variable "db_password"  {}
variable "db_port"      {}

variable "job_store_endpoint"     {}
variable "filestorage_bucket_id"  {}
variable "ssh_key_name"           {}
variable "region"                 {}
