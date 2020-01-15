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

# Two DMZ/public subnets
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
  count = local.az_count
  vpc   = true
}

resource aws_nat_gateway "ngw" {
  count = local.az_count
  subnet_id = aws_subnet.sn-dmz[count.index].id
  allocation_id = aws_eip.eip-ngw[count.index].id

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
#  - route table for every DMZ
resource "aws_route_table" "rt-private" {
  count   = local.az_count
  vpc_id  = aws_vpc.vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.ngw[count.index].id
  }
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
