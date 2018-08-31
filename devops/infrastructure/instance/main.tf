resource "aws_instance" "webserver" {
  count = "${var.webservers_count}"

  ami = "ami-04169656fea786776"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  security_groups = [
    "${var.default_security_group}",
    "${var.webserver_security_group}"
  ]

  credit_specification {
    cpu_credits = "standard"
  }

  tags {
    Instance = "${var.name}"
    Name = "${var.name}${var.worker_on_the_same_instance ? "" : "-webserver"}-${count.index}"
    Type = "webserver${var.worker_on_the_same_instance ? " and worker" : ""}"
  }

  root_block_device {
    volume_size = "${var.volume_size}"
  }
}

resource "aws_eip" "webserver" {
  count = "${var.webservers_count}"
  instance = "${element(aws_instance.webserver.*.id, count.index)}"
}

resource "aws_instance" "worker" {
  count = "${var.workers_count}"

  ami = "ami-04169656fea786776"
  instance_type = "${var.worker_instance_type}"
  key_name = "${var.key_name}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  security_groups = [
    "${var.default_security_group}"
  ]

  tags {
    Instance = "${var.name}"
    Name = "${var.name}-worker-${count.index}"
    Type = "worker"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = "${var.volume_size}"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage = "${var.db_size}"
  instance_class = "${var.db_instance_type}"
  engine = "mariadb"
  skip_final_snapshot = false
  publicly_accessible = true
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]
}

module "alarms" {
  source = "../alarms"

  alarm_actions = "${var.alarm_actions}"
  instance_ids = "${concat(aws_instance.webserver.*.id, aws_instance.worker.*.id)}"
  db_instances = ["${aws_db_instance.default.identifier}"]
}
