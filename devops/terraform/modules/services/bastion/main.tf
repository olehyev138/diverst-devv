# Module to create a bastion instance
# Inputs:
#  - sg_bn          - security group created for the instance
#  - sn_elb         - public subnet to use
#  - ssh_key_name   - ssh key resource to use

data "aws_ami" "amzn-linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name  = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "inst-bastion" {
  ami                 = data.aws_ami.amzn-linux2.id
  instance_type       = "t2.micro"
  key_name            = var.ssh_key_name

  subnet_id                   = var.sn_elb.id
  vpc_security_group_ids      = [var.sg_bn.id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}
