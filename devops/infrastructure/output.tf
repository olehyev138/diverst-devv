output "big_brother_ip" {
  value = "${aws_instance.big_brother.public_ip}"
}