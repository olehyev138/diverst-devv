output "webserver_ips" {
  value = ["${aws_eip.webserver.*.public_ip}"]
}

output "workers_ips" {
  value = ["${aws_instance.worker.*.public_ip}"]
}

output "hosts" {
  value = "${zipmap(concat(aws_instance.webserver.*.tags.Name, aws_instance.worker.*.tags.Name), concat(aws_eip.webserver.*.public_ip, aws_instance.worker.*.public_ip))}"
}
