output "big_brother_ip" {
  value = "${aws_eip.big_brother.public_ip}"
}

output "staging_ips" {
  value = "${map("webservers", module.staging.webserver_ips)}"
}

output "kp_ips" {
  value = "${map("webservers", module.kp.webserver_ips, "workers", module.kp.workers_ips)}"
}

output "ssh_hosts" {
  value = <<VALUE

${join("\n\n",
       formatlist("Host %s.diverst.com\n  HostName %s\n  User ubuntu",
                  concat(list("bigbrother"),
                         keys(module.kp.hosts),
                         keys(module.staging.hosts)),
                  concat(list("${aws_eip.big_brother.public_ip}"),
                         values(module.kp.hosts),
                         values(module.staging.hosts))))}
VALUE
}
