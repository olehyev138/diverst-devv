output "big_brother_ip" {
  value = "${aws_eip.big_brother.public_ip}"
}

output "staging_ips" {
  value = "${map("webservers", module.staging.webserver_ips)}"
}

output "kp_ips" {
  value = "${map("webservers", module.kp.webserver_ips, "workers", module.kp.workers_ips)}"
}
