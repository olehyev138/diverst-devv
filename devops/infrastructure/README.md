This is a terraform script describing current AWS infrastructure.

In order to start, put AWS credentials into `secret.auto.tfvars` file:

    aws_access_key = "AWS_ACCESS_KEY_HERE"
    aws_secret_key = "AWS_SECRET_KEY_HERE"
    cloudflare_email = "CLOUDFLARE_EMAIL_HERE"
    cloudflare_token = "CLOUDFLARE_TOKEN_HERE"

To see what actions our going to be done, use:

    terraform plan

To apply changes, use:

    terraform apply

Don't forget to commit state after your changes


### Things aren't controlled

* SNS Topic for CloudWatch
* ElasticSearch
* ElastiCache
* VPC
* RDS config (slowquery)
