resource "aws_security_group" "big_brother" {
  name        = "big_brother"
  description = "Security group for the BigBrother instance"

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.main.cidr_block}"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "big_brother" {
  instance = "${aws_instance.big_brother.id}"
}

resource "aws_instance" "big_brother" {
  ami = "ami-04169656fea786776"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.main.key_name}"

  security_groups = [
    "${aws_security_group.ssh.name}",
    "${aws_security_group.outbound.name}",
    "${aws_security_group.big_brother.name}"
  ]

  tags {
    Name = "BigBrother"
  }

  root_block_device {
    volume_size = 100
  }
}
