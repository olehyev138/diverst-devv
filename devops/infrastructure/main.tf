provider "aws" {
  region = "us-east-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

data "aws_subnet" "1b_zone" {
  id = "subnet-3b6c7110"
}

data "aws_subnet" "1d_zone" {
  id = "subnet-43a5461b"
}

resource "aws_key_pair" "main" {
  key_name = "main"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBavSqSVS0AG8Fvm0tiE1IPvVuThwIUs09OzhxNeG+AJj8titBJ0vjhZtQ5XavRkMuNHJjZx0s62D/QTfiRmZ4e7K8wcCzV6FaIKMdumGTdcqVHVFFJEThgS6qLl5pZUCOZii7uIqM7jUgkVlbMloj0sw5lbUy2qVDQrkRbNp7cYQAzM0symtMgf4/3POiStqUxAmwSrMAE9R+AArUqCeGnOT0frh7D63zUvjgw9L4eL/wdPknYuRCz2ucyJa7JgCNZeWbVRbjTNHVdf3s9UDRSRJRlkrKYrPx8+3Vf3cR99VM49XmXMV2/y06EmBuA8TxxWPOPJWguyqrus5PT6V/ tech@diverst.com"
}

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
