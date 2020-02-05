# Base env module for all production/client environments

module "vpc" {
  source = "../../../modules/networking/vpc"
}

module "sec" {
  source = "../../../modules/networking/sec"

  vpc_id  = module.vpc.vpc.id
}

module "bastion" {
  source = "../../../modules/services/bastion"

  sg_bn         = module.sec.sg_bn
  sn_elb        = module.vpc.sn_dmz[0]
  ssh_key_name  = var.ssh_key_name
}

module "db" {
  source = "../../../modules/data/db"

  db_name       = "diverst_production"
  db_username   = var.db_username
  db_password   = var.db_password

  sn_db         = module.vpc.sn_db
  sg_db         = module.sec.sg_db
}

module "job_store" {
  source = "../../../modules/data/job_store"

  sn_ec       = module.vpc.sn_db
  sg_ec       = module.sec.sg_db
  node_type   = "cache.t2.micro"
}

module "backend" {
  source = "../../../modules/services/backend"

  env_name  = var.env_name
  region    = var.region
  vpc_id    = module.vpc.vpc.id

  sn_elb  = module.vpc.sn_dmz
  sg_elb  = module.sec.sg_dmz
  sn_app  = module.vpc.sn_app
  sg_app  = module.sec.sg_app

  db_address  = module.db.db_address
  db_port     = module.db.db_port
  db_username = var.db_username
  db_password = var.db_password

  job_store_endpoint = module.job_store.endpoint

  filestorage_bucket_id = module.filestorage.filestorage_bucket_id
  ssh_key_name = var.ssh_key_name
}

module "frontend" {
  source = "../../../modules/services/frontend"

  env_name = var.env_name
}

module "filestorage" {
  source = "../../../modules/data/filestorage"

  env_name = var.env_name
}

data "aws_instance" "bastion" {
  depends_on = [module.bastion]

  filter {
    name    = "tag:Name"
    values  = ["bastion"]
  }
}

data "aws_instance" "app" {
  depends_on = [module.backend]

  filter {
    name    = "tag:Name"
    values  = ["${var.env_name}-env"]
  }
}
