# Module to create AWS RDS
# Inputs:
#   - sg_db - security group for database
#   - sn_db - array of subnets for database
# Outputs:
#   - db_endpoint - endpoint for database

resource "aws_db_subnet_group" "sn_db_group" {
  name          = "main"
  subnet_ids    = var.sn_db.*.id

  tags = {
    Name = "db subnet group"
  }
}

resource "aws_db_instance" "db" {
  instance_class            = "db.t2.micro"
  engine                    = "mariadb"
  allocated_storage         = 20

  db_subnet_group_name      = aws_db_subnet_group.sn_db_group.name
  vpc_security_group_ids    = [var.sg_db.id]
  multi_az                  = true

  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password

  # TODO: backup config
  backup_retention_period   = 0
  final_snapshot_identifier = "Ignore"
  skip_final_snapshot       = true
}
