provider "aws" {
}

terraform {
  required_version = "~> 0.12.24"

  required_providers {
    aws     = "~> 2.58"
    random  = "~> 2.2"
  }

  backend "s3" {
    bucket          = "testing-zmqglbkg"
    key             = "terraform/terraform.tfstate"
    dynamodb_table  = "testing-tf-statelock"
    encrypt         = "true"
  }
}

# SSH key
# SSH key files are generated before terraform is run
resource "aws_key_pair" "aws-tf-key" {
  key_name    = var.ssh_key_name
  public_key  = file("~/.ssh/testing.pub")
}

module "prod" {
  source = "../base-prod"

  az_count            = var.az_count
  nat_gateway_enabled = var.nat_gateway_enabled

  backend_solution_stack  = var.backend_solution_stack
  backend_asg_min         = var.backend_asg_min
  backend_asg_max         = var.backend_asg_max
  backend_ec2_type        = var.backend_ec2_type

  sidekiq_username = var.sidekiq_username
  sidekiq_password = var.sidekiq_password

  db_class                    = var.db_class
  multi_az                    = var.multi_az
  db_allocated_storage        = var.db_allocated_storage
  db_backup_retention         = var.db_backup_retention
  db_backup_window            = var.db_backup_window
  db_deletion_protection      = var.db_deletion_protection
  db_apply_immediately        = var.db_apply_immediately
  db_maintenance_window       = var.db_maintenance_window

  env_name      = var.env_name
  region        = var.region
  ssh_key_name  = var.ssh_key_name
  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password
}
