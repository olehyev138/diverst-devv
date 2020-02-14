# Module to create AWS RDS
# Inputs:
#   - sg_db - security group for database
#   - sn_db - array of subnets for database
# Outputs:
#   - db_endpoint - endpoint for database

resource "aws_db_subnet_group" "sn_db_group" {
  name          = "${var.env_name}-sn-db-group"
  subnet_ids    = var.sn_db.*.id
}

resource "aws_db_instance" "db" {
  identifier                = "${var.env_name}-db"
  instance_class            = var.db_class
  engine                    = "mariadb"
  allocated_storage         = var.allocated_storage

  db_subnet_group_name      = aws_db_subnet_group.sn_db_group.name
  vpc_security_group_ids    = [var.sg_db.id]
  multi_az                  = true

  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password

  deletion_protection       = var.deletion_protection
  maintenance_window        = var.maintenance_window
  apply_immediately         = var.apply_immediately

  backup_retention_period   = var.backup_retention
  backup_window             = var.backup_window
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.env_name}-db-snapshot-final"
}
