# Base env module for all production/client environments

module "vpc" {
  source              = "../../../modules/networking/vpc"
  ssh_key_name        = var.ssh_key_name
  az_count            = var.az_count
  nat_gateway_enabled = var.nat_gateway_enabled
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

  env_name      = var.env_name
  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password

  multi_az                = var.multi_az
  db_class                = var.db_class
  allocated_storage       = var.db_allocated_storage
  backup_retention        = var.db_backup_retention
  backup_window           = var.db_backup_window
  deletion_protection     = var.db_deletion_protection
  apply_immediately       = var.db_apply_immediately
  maintenance_window      = var.db_maintenance_window

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

  solution_stack  = var.backend_solution_stack
  asg_min         = var.backend_asg_min
  asg_max         = var.backend_asg_max
  ec2_type        = var.backend_ec2_type

  sn_elb  = module.vpc.sn_dmz
  sg_elb  = module.sec.sg_dmz
  sn_app  = module.vpc.sn_app
  sg_app  = module.sec.sg_app

  sidekiq_username = var.sidekiq_username
  sidekiq_password = var.sidekiq_password

  db_address  = module.db.db_address
  db_name     = var.db_name
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

module "analytics" {
  source = "../../../modules/services/analytics"

  env_name  = var.env_name
  sn_db     = module.vpc.sn_db
  sg_db     = module.sec.sg_db
  interval  = var.analytics_interval

  db_address  = module.db.db_address
  db_name     = var.db_name
  db_port     = module.db.db_port
  db_username = var.db_username
  db_password = var.db_password
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

  filter {
    name    = "instance-state-name"
    values  = ["running"]
  }
}
