output "vpc" {
  value = aws_vpc.vpc
  description = "VPC to contain all of the infrastructure"
}

output "sn_dmz" {
  value       = aws_subnet.sn-dmz
  description = "List of DMZ subnets"
}

output "sn_app" {
  value       = aws_subnet.sn-app
  description = "List of app subnets"
}

output "sn_db" {
  value       = aws_subnet.sn-db
  description = "List of db subnets"
}

