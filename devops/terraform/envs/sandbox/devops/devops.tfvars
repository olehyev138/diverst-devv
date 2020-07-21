env_name            = "devops"
region              = "us-east-1"
ssh_key_name        = "key_devops"
az_count            = 2
nat_gateway_enabled = false

backend_solution_stack  = "64bit Amazon Linux 2018.03 v2.11.7 running Ruby 2.6 (Puma)"
rails_master_key        = "0cd095760c9ff9a780b97332b683bc3a"
backend_asg_min         = 1
backend_asg_max         = 2
backend_ec2_type        = "t2.micro"

sidekiq_username = "admin"

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

analytics_interval = "12 hours"

rollbar_env           = "beta-testing"
mailgun_domain        = "mg.diverst.com"
rollbar_access_token  = "null"
mailgun_api_key       = "null"
embedly_key           = "null"

