output bastion_ip {
  value = module.prod.bastion_ip
}

output app_ip {
  value = module.prod.app_ip
}

output backend_endpoint {
  value = module.prod.backend_endpoint
}

output frontend_endpoint {
  value = module.prod.frontend_endpoint
}

output frontend_bucket {
  value = module.prod.frontend_bucket
}
