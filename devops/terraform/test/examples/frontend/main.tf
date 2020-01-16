provider "aws" {
  profile	= "default"
  region	= "us-west-2"
}

module "frontend" {
  source    = "../../../modules/services/frontend"
  env_name  = "test"
}
