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

resource "aws_elastic_beanstalk_environment" "eb_app_env" {
  name			      = "${var.env_name}-env"
  application		  = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.2 running Ruby 2.6 (Puma)"
  tier                = "WebServer"

  # Instance Profile
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  # VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
    resource  = ""
  }

  # Auto Scaling settings

  # Minimum instances
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.asg_min
    resource  = ""
  }

  # Maximum instances
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = var.asg_max
    resource = ""
  }

  # EC2 Type
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = var.ec2_type
    resource = ""
  }

  # Load Balancer type
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
    resource  = ""
  }

  # Subnet for load balancer
  setting {
    namespace   = "aws:ec2:vpc"
    name        = "ELBSubnets"
    value       = join(",", sort(var.sn_elb.*.id))
    resource  = ""
  }

  # Subnet for ASG EC2 instances
  setting {
    namespace   = "aws:ec2:vpc"
    name        = "Subnets"
    value       = join(",", sort(var.sn_app.*.id))
    resource  = ""
  }

  # Security group for load balancer - have to use both settings
  setting {
    namespace   = "aws:elbv2:loadbalancer"
    name        = "ManagedSecurityGroup"
    value       = var.sg_elb.id
    resource  = ""
  }

  setting {
    namespace   = "aws:elbv2:loadbalancer"
    name        = "SecurityGroups"
    value       = var.sg_elb.id
    resource  = ""
  }

  # Security group for ASG EC2 instances
  setting {
    namespace   = "aws:autoscaling:launchconfiguration"
    name        = "SecurityGroups"
    value       = var.sg_app.id
    resource  = ""
  }

  # Env Variables
  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_ENV"
    value       = "production"
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_SKIP_MIGRATIONS"
    value       = "true"
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_SKIP_ASSET_COMPILATION"
    value       = "true"
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "PORT"
    value        = "80"
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "REDIS_PROVIDER"
    value        = "REDIS_URL"
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "REDIS_URL"
    value       = "redis://${var.job_store_endpoint}:6379/0"
    resource  = ""
  }

  # TODO: use vars & secrets
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "SIDEKIQ_DASHBOARD_USERNAME"
    value = "admin"
    resource  = ""
  }

  # TODO: use vars & secrets
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "SIDEKIQ_DASHBOARD_PASSWORD"
    value = "admin"
    resource  = ""
  }

  # TODO: generate this & store somewhere proper
  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "RAILS_MASTER_KEY"
    value        = "0cd095760c9ff9a780b97332b683bc3a"
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "S3_BUCKET_NAME"
    value        = var.filestorage_bucket_id
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "S3_REGION"
    value        = var.region
    resource  = ""
  }

  setting {
    namespace   = "aws:autoscaling:launchconfiguration"
    name        = "EC2KeyName"
    value       = var.ssh_key_name
    resource  = ""
  }

  # Database env variables

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_HOST"
    value        = var.db_address
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_USERNAME"
    value        = var.db_username
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_PASSWORD"
    value        = var.db_password
    resource  = ""
  }

  setting {
    namespace   = "aws:elasticbeanstalk:application:environment"
    name        = "DATABASE_PORT"
    value        = var.db_port
    resource  = ""
  }
}
