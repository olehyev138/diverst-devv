output bastion_ip {
  value = module.prod.bastion_ip
}

output app_ip {
  value = module.prod.app_ip
}

output frontend_endpoint {
  value = module.prod.frontend_endpoint
}

output backend_endpoint {
  value = module.prod.backend_endpoint
}
