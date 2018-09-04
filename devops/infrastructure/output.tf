output "big_brother_ip" {
  value = "${aws_eip.big_brother.public_ip}"
}
