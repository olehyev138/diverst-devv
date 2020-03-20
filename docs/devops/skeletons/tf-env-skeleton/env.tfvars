# Skeleton <client-name>.tfvars
# Is copied and filled out when creating a new client environment

env_name      = "<client-name>"
region        = "<region>"
ssh_key_name  = "key_<client-name"

backend_asg_min   = 1
backend_asg_max   = 4
backend_ec2_type  = "t2.small"

sidekiq_username = "admin"
sidekiq_password = "<password>"

db_class                    = "db.t2.small"
db_allocated_storage        = 20
db_backup_retention         = 31
db_backup_window            = null
db_deletion_protection      = true
db_apply_immediately        = true
db_maintenance_window       = null

db_name       = "diverst_production"
db_username   = "admin"
db_password   = "<password>"
