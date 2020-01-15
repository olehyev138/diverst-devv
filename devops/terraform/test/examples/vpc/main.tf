provider "aws" {
  profile	= "default"
  region	= "us-west-2"
}

module "vpc" {
  source = "../../../modules/networking/vpc"
}
