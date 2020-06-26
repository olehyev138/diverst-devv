# Skeleton <client-name>.tfvars
# Is copied and filled out when creating a new client environment

env_name            = "<client-name>"
region              = "<region>"
ssh_key_name        = "key_<client-name"
az_count            = 2
nat_gateway_enabled = true

backend_solution_stack  = "64bit Amazon Linux 2018.03 v2.11.7 running Ruby 2.6 (Puma)"
backend_asg_min         = 1
backend_asg_max         = 4
backend_ec2_type        = "t2.small"

sidekiq_username = "admin"

db_class                    = "db.t2.small"
multi_az                    = false
db_allocated_storage        = 20
db_backup_retention         = 31
db_backup_window            = null
db_deletion_protection      = true
db_apply_immediately        = true
db_maintenance_window       = null

db_name       = "diverst_production"
db_username   = "admin"

analytics_interval = "12 hours"

rollbar_env     = "<rollbar_env>"
mailgun_domain  = "mg.diverst.com"
