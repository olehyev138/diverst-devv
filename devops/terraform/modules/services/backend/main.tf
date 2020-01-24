# Module to create Elastic Beanstalk app for Rails API
# Inputs:
#  - vpc_id     - custom vpc to use
#  - sn_elb     - public dmz subnets for load balancer
#  - sg_elb     - security group for load balancer
#  - sn_app     - subnet for ec2 instances
#  - sg_app     - security group for ec2 instances

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name  = "eb_instance_profile"
  role  = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name                = "eb_role"
  assume_role_policy  = file("${path.module}/assume_policy.json")
}

resource "aws_iam_role_policy" "policy" {
  name    = "s3_access_policy"
  role    = aws_iam_role.role.id
  policy  = file("${path.module}/policy.json")
}

resource "aws_elastic_beanstalk_application" "eb_app" {
  name		    = var.env_name
  description	= "Backend for ${var.env_name}"
}

resource "aws_elastic_beanstalk_environment" "diverst-env" {
  name			      = "${var.env_name}-env"
  application		  = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.2 running Ruby 2.6 (Puma)"
  tier                = "WebServer"

  # Instance Profile
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.arn
  }

  # VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  # Subnet for load balancer
  setting {
    namespace   = "aws:ec2:vpc"
    name        = "ELBSubnets"
    value       = join(",", var.sn_elb.*.id)
  }

  # Subnet for ASG EC2 instances
  setting {
    namespace   = "aws:ec2:vpc"
    name        = "Subnets"
    value       = join(",", var.sn_app.*.id)
  }

  # Security group for load balancer - have to use both settings
  setting {
    namespace   = "aws:elbv2:loadbalancer"
    name        = "ManagedSecurityGroup"
    value       = var.sg_elb.id
  }

  setting {
    namespace   = "aws:elbv2:loadbalancer"
    name        = "SecurityGroups"
    value       = var.sg_elb.id
  }

  # Security group for ASG EC2 instances
  setting {
    namespace   = "aws:autoscaling:launchconfiguration"
    name        = "SecurityGroups"
    value       = var.sg_app.id
  }

  # Env Variables
  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_ENV"
    value       = "production"
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_SKIP_MIGRATIONS"
    value       = "true"
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_SKIP_ASSET_COMPILATION"
    value       = "true"
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "PORT"
    value        = "80"
  }

  # TODO: generate this & store somewhere proper
  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_MASTER_KEY"
    value        = "0cd095760c9ff9a780b97332b683bc3a"
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "S3_BUCKET_NAME"
    value        = var.filestorage_bucket_id
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "S3_REGION"
    value        = "us-east-2"
  }

  setting {
    namespace   = "aws:autoscaling:launchconfiguration"
    name        = "EC2KeyName"
    value       = var.ssh_key_name
  }

  # Database env variables

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_HOST"
    value        = var.db_address
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_USERNAME"
    value        = var.db_username
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_PASSWORD"
    value        = var.db_password
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_PORT"
    value        = var.db_port
  }
}
