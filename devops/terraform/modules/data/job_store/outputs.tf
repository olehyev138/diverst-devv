# TODO: will have to channge to `configuration_endpoint_address` if cluster mode is enabled
output "endpoint" {
  value         = aws_elasticache_replication_group.job_ec_store.primary_endpoint_address
  description   = "Address of primary node"
}
