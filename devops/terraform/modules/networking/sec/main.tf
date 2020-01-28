# Module to create security groups for network setup
# Note: Assumes & relies on a knowledge of the overall infrastructure setup
#  - creates sg for DMZ
#  - creates sg for private app subnets
#  - creates sg for private db subnets
#  - creates sg for a bastion instance
# Inputs:
#  - vpc_id - id of custom vpc the sg's are attached to
#  - sn_app - single app subnet - needed for bastion routing
#  - sn_db  - db subnet list
# Outputs:
#  - sg_dmz     - sg for dmz subnets
#  - sg_app     - sg for private app subnets
#  - sg_db      - sg for private database
#  - sg_bn      - sg for bastion instance


#
## DMZ SG & rules
#

resource "aws_security_group" "sg-dmz" {
  name          = "sg_dmz"
  description   = "Security group for elastic load balancer"
  vpc_id        = var.vpc_id
}

resource "aws_security_group_rule" "sg-dmz-ing-allow-all" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg-dmz.id
}

resource "aws_security_group_rule" "sg-dmz-egr-allow-all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg-dmz.id
}

#
## App SG & rules
#

resource "aws_security_group" "sg-app" {
  name          = "sg_app"
  description   = "Security group for app subnets"
  vpc_id        = var.vpc_id
}

# Allow internet traffic from dmz subnet
resource "aws_security_group_rule" "sg-app-ing-allow-dmz" {
  type                      = "ingress"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.sg-dmz.id

  security_group_id = aws_security_group.sg-app.id
}

# Allow SSH traffic from bastion
resource "aws_security_group_rule" "sg-app-ing-allow-bn" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  source_security_group_id = aws_security_group.sg-bn.id

  security_group_id = aws_security_group.sg-app.id
}

resource "aws_security_group_rule" "sg-app-egr-allow-all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg-app.id
}

#
## DB SG & rules
#

resource "aws_security_group" "sg-db" {
  name          = "sg_db"
  description   = "Security group for db"
  vpc_id        = var.vpc_id
}

# Allow DB traffic from app subnet
resource "aws_security_group_rule" "sg-db-ing-allow-dmz" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.sg-app.id

  security_group_id = aws_security_group.sg-db.id
}

# Allow Redis traffic from anywhere
resource "aws_security_group_rule" "sg-db-ing-allow-redis" {
  type            = "ingress"
  from_port       = 0
  to_port         = 6379
  protocol        = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg-db.id
}

resource "aws_security_group_rule" "sg-db-egr-allow-all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg-db.id
}

#
## Bastion SG & rules
#

resource "aws_security_group" "sg-bn" {
  name          = "sg_bn"
  description   = "Security group for bastion instance"
  vpc_id        = var.vpc_id
}

# Allow SSH traffic from internet
resource "aws_security_group_rule" "sg-bn-ing-allow-ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  self = false

  security_group_id = aws_security_group.sg-bn.id
}

# Allow egress SSH traffic to app subnets
resource "aws_security_group_rule" "sg-bn-egr-allow-app" {
  type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = aws_security_group.sg-app.id

  security_group_id = aws_security_group.sg-bn.id
}
