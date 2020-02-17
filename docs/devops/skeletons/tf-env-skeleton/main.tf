# Skeleton main.tf
# Is copied and filled out when creating a new client environment

provider "aws" {
}

terraform {
  backend "s3" {
    bucket          = "<client-tf-state-bucket>"
    key             = "terraform/terraform.tfstate"
    dynamodb_table  = "<client-name>-tf-statelock"
    encrypt         = "true"
  }
}

# SSH key
# SSH key files are generated before terraform is run
resource "aws_key_pair" "aws-tf-key" {
  key_name    = var.ssh_key_name
  public_key  = file("<key-directory-path>")
}

module "prod" {
  source = "../base-prod"

  env_name      = var.env_name
  region        = var.region
  ssh_key_name  = var.ssh_key_name

  backend_asg_min   = var.backend_asg_min
  backend_asg_max   = var.backend_asg_max
  backend_ec2_type  = var.backend_ec2_type

  sidekiq_username = var.sidekiq_username
  sidekiq_password = var.sidekiq_password

  db_class                    = var.db_class
  db_allocated_storage        = var.db_allocated_storage
  db_backup_retention         = var.db_backup_retention
  db_backup_window            = var.db_backup_window
  db_deletion_protection      = var.db_deletion_protection
  db_apply_immediately        = var.db_apply_immediately
  db_maintenance_window       = var.db_maintenance_window

  db_username   = var.db_username
  db_password   = var.db_password
}
