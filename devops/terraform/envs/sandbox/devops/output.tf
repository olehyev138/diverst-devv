output bastion_ip {
  value = module.sandbox.bastion_ip
}

output app_ip {
  value = module.sandbox.app_ip
}

output backend_endpoint {
  value = module.sandbox.backend_endpoint
}

output frontend_endpoint {
  value = module.sandbox.frontend_endpoint
}

output frontend_bucket {
  value = module.sandbox.frontend_bucket
}
