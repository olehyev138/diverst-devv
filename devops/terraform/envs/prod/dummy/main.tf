# Env module for dummy/test prod

provider "aws" {
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region	              = "us-west-2"
  profile	              = "staging"

  assume_role {
    role_arn = "arn:aws:iam::823323907715:role/allow-ops-full-access"
  }
}

terraform {
  backend "s3" {
    bucket          = "staging-wpxaguyb"
    key             = "terraform/terraform.tfstate"
    region          = "us-west-2"
    dynamodb_table  = "staging-tf-statelock"
    encrypt         = "true"

    profile         = "staging"
    role_arn        = "arn:aws:iam::823323907715:role/allow-ops-full-access"
  }
}

# SSH key
# SSH key files are generated before terraform is run
resource "aws_key_pair" "aws-tf-key" {
  key_name    = var.ssh_key_name
  public_key  = file("keys/diverst.pub")
}

module "prod" {
  source = "../base-prod"

  env_name      = var.env_name
  ssh_key_name  = var.ssh_key_name
  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password
}
