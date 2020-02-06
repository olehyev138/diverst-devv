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
  db_username   = var.db_username
  db_password   = var.db_password
}
