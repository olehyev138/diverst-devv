resource "aws_elasticache_subnet_group" "sn_ec_group" {
  name          = "main"
  subnet_ids    = var.sn_ec.*.id
}

# TODO:
#  - turn on cluster mode
#  - review configuration
resource "aws_elasticache_replication_group" "job_ec_store" {
  replication_group_id          = "job-ec-store"
  replication_group_description = "redis cluster for sidekiq"
  port                          = 6379
  automatic_failover_enabled    = true
  parameter_group_name          = "default.redis5.0"
  number_cache_clusters         = 2
  node_type                     = var.node_type
  subnet_group_name             = aws_elasticache_subnet_group.sn_ec_group.name
  security_group_ids            = [var.sg_ec.id]
}
