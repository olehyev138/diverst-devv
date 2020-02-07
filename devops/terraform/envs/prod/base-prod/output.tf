output "bastion_ip" {
  value = data.aws_instance.bastion.public_ip
}

output "app_ip" {
  value = data.aws_instance.app.private_ip
}

output "frontend_endpoint" {
  value = module.frontend.frontend_endpoint
}

output "backend_endpoint" {
  value = module.backend.backend_endpoint
}

output "frontend_bucket" {
  value = module.frontend.frontend_bucket
}
