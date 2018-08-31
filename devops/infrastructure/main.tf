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

resource "aws_sns_topic" "server_outage" {
  name = "server-outages"
}

resource "aws_key_pair" "main" {
  key_name = "main"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBavSqSVS0AG8Fvm0tiE1IPvVuThwIUs09OzhxNeG+AJj8titBJ0vjhZtQ5XavRkMuNHJjZx0s62D/QTfiRmZ4e7K8wcCzV6FaIKMdumGTdcqVHVFFJEThgS6qLl5pZUCOZii7uIqM7jUgkVlbMloj0sw5lbUy2qVDQrkRbNp7cYQAzM0symtMgf4/3POiStqUxAmwSrMAE9R+AArUqCeGnOT0frh7D63zUvjgw9L4eL/wdPknYuRCz2ucyJa7JgCNZeWbVRbjTNHVdf3s9UDRSRJRlkrKYrPx8+3Vf3cR99VM49XmXMV2/y06EmBuA8TxxWPOPJWguyqrus5PT6V/ tech@diverst.com"
}

resource "aws_security_group" "basic" {
  name        = "basic"
  description = "Allow all outgoung, incoming SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "Allow incoming 3000 traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "staging" {
  source = "./instance"

  name = "staging"
  key_name = "${aws_key_pair.main.key_name}"
  worker_on_the_same_instance = true
  default_security_group = "${aws_security_group.basic.name}"
  webserver_security_group = "${aws_security_group.webserver.name}"

  db_size = 5
  db_instance_type = "db.t2.micro"

  alarm_actions = ["${aws_sns_topic.server_outage.arn}"]
}

module "kp" {
  source = "./instance"

  name = "kp"
  key_name = "${aws_key_pair.main.key_name}"
  worker_instance_type = "t3.large"

  webservers_count = 3
  workers_count = 1
  db_size = 20
  db_instance_type = "db.t2.small"

  default_security_group = "${aws_security_group.basic.name}"
  webserver_security_group = "${aws_security_group.webserver.name}"

  alarm_actions = ["${aws_sns_topic.server_outage.arn}"]
}
