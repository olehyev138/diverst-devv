env_name            = "devops"
region              = "us-east-1"
ssh_key_name        = "key_devops"
az_count            = 2
nat_gateway_enabled = false

backend_solution_stack  = "64bit Amazon Linux 2018.03 v2.11.4 running Ruby 2.6 (Puma)"
backend_asg_min         = 1
backend_asg_max         = 2
backend_ec2_type        = "t2.micro"

sidekiq_username = "admin"
sidekiq_password = "password123"

db_class                    = "db.t2.micro"
multi_az                    = false
db_allocated_storage        = 20
db_backup_retention         = 31
db_backup_window            = null
db_deletion_protection      = true
db_apply_immediately        = true
db_maintenance_window       = null

db_name       = "diverst"
db_username   = "mainuser"
db_password   = "password123"

analytics_interval = "12 hours"
