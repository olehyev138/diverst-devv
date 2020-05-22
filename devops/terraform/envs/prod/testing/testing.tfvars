env_name            = "testing"
region              = "us-east-1"
ssh_key_name        = "key_testing"
az_count            = 2
nat_gateway_enabled = false


backend_solution_stack  = "64bit Amazon Linux 2018.03 v2.11.4 running Ruby 2.6 (Puma)"
backend_asg_min         = 1
backend_asg_max         = 4
backend_ec2_type        = "t2.small"

sidekiq_username = "admin"

db_class                    = "db.t2.micro"
multi_az                    = false
db_allocated_storage        = 20
db_backup_retention         = 0
db_backup_window            = null
db_deletion_protection      = false
db_apply_immediately        = true
db_maintenance_window       = null

db_name                     = "diverst_production"
db_username                 = "admin"

analytics_interval = "12 hours"

rollbar_env     = "beta-testing"
mailgun_domain  = "mg.diverst.com"
