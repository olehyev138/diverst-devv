output "sg_dmz" {
  value = aws_security_group.sg-dmz
  description = "Security group for DMZ instances"
}

output "sg_app" {
  value = aws_security_group.sg-app
  description = "Security group for app instances"
}

output "sg_db" {
  value = aws_security_group.sg-db
  description = "Security group for db services"
}

output "sg_bn" {
  value = aws_security_group.sg-bn
  description = "Security group for bastion instance"
}
