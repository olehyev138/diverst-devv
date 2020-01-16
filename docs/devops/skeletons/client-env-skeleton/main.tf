# Skeleton main.tf
# Is copied and filled out when creating a new client environment

provider "aws" {
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region	              = "us-west-2"
  profile	              = "<aws-profile>"

  assume_role {
    role_arn = "<aws-client-account-role>"
  }
}

terraform {
  backend "s3" {
    bucket          = "<client-tf-state-bucket>"
    key             = "terraform/terraform.tfstate"
    region          = "us-west-2"
    dynamodb_table  = "<client-name>-tf-statelock"
    encrypt         = "true"

    profile         = "staging"
    role_arn        = "<aws-client-account-role>"
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
  ssh_key_name  = var.ssh_key_name
  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password
}
