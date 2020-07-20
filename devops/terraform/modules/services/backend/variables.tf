variable "env_name"         {}
variable "vpc_id"           {}
variable "solution_stack"   {}
variable "rails_master_key" {}

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
variable "db_name"      {}
variable "db_username"  {}
variable "db_password"  {}
variable "db_port"      {}

variable "job_store_endpoint"     {}
variable "filestorage_bucket_id"  {}
variable "ssh_key_name"           {}
variable "region"                 {}

variable "rollbar_env"          {}
variable "rollbar_access_token" {}
variable "mailgun_domain"       {}
variable "mailgun_api_key"      {}
variable "embedly_key"          {}