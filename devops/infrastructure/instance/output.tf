output "webserver_ips" {
  value = ["${aws_eip.webserver.*.public_ip}"]
}

output "workers_ips" {
  value = ["${aws_instance.worker.*.public_ip}"]
}
