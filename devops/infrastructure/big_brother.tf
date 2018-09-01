resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow incoming SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound" {
  name        = "outbound"
  description = "Allow any outgoing traffic"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "1a_zone" {
  id = "subnet-6cc8a709"
}

data "aws_subnet" "1b_zone" {
  id = "subnet-3b6c7110"
}

data "aws_subnet" "1c_zone" {
  id = "subnet-c601c8b0"
}

data "aws_subnet" "1d_zone" {
  id = "subnet-43a5461b"
}

data "aws_subnet" "1e_zone" {
  id = "subnet-0c028731"
}

data "aws_subnet" "1f_zone" {
  id = "subnet-65d45e69"
}

resource "aws_security_group" "big_brother" {
  name        = "big_brother"
  description = "Security group for the BigBrother instance"

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.1a_zone.cidr_block}"]
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.1b_zone.cidr_block}"]
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.1c_zone.cidr_block}"]
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.1d_zone.cidr_block}"]
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.1e_zone.cidr_block}"]
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.1f_zone.cidr_block}"]
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
