# Module to create a base network setup
# Inputs
#  - none
# Outputs:
#  - vpc            - id of custom vpc created
#  - sn_dmz         - list of dmz subnets
#  - sn_app         - list of app subnets
#  - sn_db          - list of db subnets

locals {
  # How many AZ's we will be using
  az_count = 2
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block              = "10.0.0.0/16"
  instance_tenancy        = "default"
  enable_dns_hostnames    = "true"
  enable_dns_support      = "true"
}

# DMZ/public subnets
resource "aws_subnet" "sn-dmz" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

# Two app subnets
resource "aws_subnet" "sn-app" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${count.index + 2}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
}

# Two DB subnets
resource "aws_subnet" "sn-db" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${count.index + 4}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# NAT gateway & EIP per AZ
resource aws_eip "eip-ngw" {
  count =  var.nat_gateway_enabled ? local.az_count : 0
  vpc   = true
}

resource aws_nat_gateway "ngw" {
  count           =  var.nat_gateway_enabled ? local.az_count : 0
  subnet_id       = aws_subnet.sn-dmz[count.index].id
  allocation_id   = aws_eip.eip-ngw[count.index].id

  depends_on = [aws_internet_gateway.igw]
}

# DMZ routing
#  - create public route table & route table associations for all AZ's
resource "aws_route_table" "rt-dmz" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate each dmz subnet with the dmz route table
resource "aws_route_table_association" "rt-asc-dmz" {
  count           = local.az_count
  subnet_id       = aws_subnet.sn-dmz[count.index].id
  route_table_id  = aws_route_table.rt-dmz.id
}

# Private subnet routing
#  - 1 route table per AZ
resource "aws_route_table" "rt-private" {
  count   = local.az_count
  vpc_id  = aws_vpc.vpc.id

}

# Route for NAT Gateway
#  - disabled if var.nat_gateway_enabled is set to false
resource aws_route "route-ng" {
  count                   = var.nat_gateway_enabled ? local.az_count : 0
  destination_cidr_block  = "0.0.0.0/0"
  route_table_id          = aws_route_table.rt-private[count.index].id
  nat_gateway_id          = aws_nat_gateway.ngw[count.index].id
}

# Associate each app subnet with each private route table
resource aws_route_table_association "rt-asc-app" {
  count           = local.az_count
  subnet_id       = aws_subnet.sn-app[count.index].id
  route_table_id  = aws_route_table.rt-private[count.index].id
}

# Associate each db subnet with each private route table
resource aws_route_table_association "rt-asc-db" {
  count           = local.az_count
  subnet_id       = aws_subnet.sn-db[count.index].id
  route_table_id  = aws_route_table.rt-private[count.index].id
}


#
# NAT Instance resources
#   - Optional, used as NAT Gateway alternative if var.nat_gateway_enabled is set to false
#   - Lives inside ASG, max size is currently *1* - ASG is configured to use with all DMZ subnets however
#   - All NAT instance resources are either enabled or disabled via `count: var.nat_gateway_enabled ? 0 : 1`,
#     this is done as a workaround to lack of support for conditional modules
#   - Sourced mostly from: https://github.com/int128/terraform-aws-nat-instance
#

# AMI of the latest Amazon Linux 2
#  - AWS provided NAT AMI is outdated
data "aws_ami" "aws-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_security_group" "sg-nat" {
  count       = var.nat_gateway_enabled ? 0 : 1
  name        = "sg_nat"
  vpc_id      = aws_vpc.vpc.id
  description = "Security group for NAT instance"
}

resource "aws_security_group_rule" "sg-nat-ingress" {
  count             = var.nat_gateway_enabled ? 0 : 1
  security_group_id = aws_security_group.sg-nat[0].id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
}

resource "aws_security_group_rule" "sg-nat-egress" {
  count             = var.nat_gateway_enabled ? 0 : 1
  security_group_id = aws_security_group.sg-nat[0].id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
}

resource "aws_network_interface" "eni-nat" {
  count             = var.nat_gateway_enabled ? 0 : 1
  security_groups   = [aws_security_group.sg-nat[0].id]
  subnet_id         = aws_subnet.sn-dmz[0].id
  source_dest_check = false
  description       = "ENI for NAT instance"

  depends_on        = [aws_subnet.sn-dmz]
}

resource "aws_eip" "eip-nat" {
  count             = var.nat_gateway_enabled ? 0 : 1
  network_interface = aws_network_interface.eni-nat[0].id
}

resource "aws_route" "route-nat" {
  count                   = var.nat_gateway_enabled ? 0 : local.az_count
  route_table_id          = aws_route_table.rt-private[count.index].id
  destination_cidr_block  = "0.0.0.0/0"
  network_interface_id    = aws_network_interface.eni-nat[0].id
}

resource "aws_launch_template" "launch-tmpl-nat" {
  count         = var.nat_gateway_enabled ? 0 : 1
  name          = "nat-launch-tmpl"
  image_id      = data.aws_ami.aws-ami.id
  key_name      = var.ssh_key_name
  instance_type = "t2.micro"

  iam_instance_profile {
    arn = aws_iam_instance_profile.nat-instance-profile[0].arn
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg-nat[0].id]
    delete_on_termination       = true
  }

  user_data = base64encode(
    templatefile("${path.module}/data/init.sh", {
      eni_id = aws_network_interface.eni-nat[0].id
    })
  )

  description = "Launch template for NAT instance"
  tags = {
    Name = "nat-instance"
  }
}

resource "aws_autoscaling_group" "nat-asg" {
  count               = var.nat_gateway_enabled ? 0 : 1
  name                = "nat-asg"
  desired_capacity    = var.nat_gateway_enabled ? 0 : 1
  min_size            = var.nat_gateway_enabled ? 0 : 1
  max_size            = 1
  vpc_zone_identifier = [aws_subnet.sn-dmz[0].id]

  launch_template {
    id = aws_launch_template.launch-tmpl-nat[0].id
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_launch_template.launch-tmpl-nat]
}

resource "aws_iam_instance_profile" "nat-instance-profile" {
  count         = var.nat_gateway_enabled ? 0 : 1
  name          = "nat-instance-profile"
  role          = aws_iam_role.nat-iam-role[0].name
}

resource "aws_iam_role" "nat-iam-role" {
  count               = var.nat_gateway_enabled ? 0 : 1
  name                = "nat-role"
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "eni" {
  count       = var.nat_gateway_enabled ? 0 : 1
  role        = aws_iam_role.nat-iam-role[0].name
  name        = "nat-eni-policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

