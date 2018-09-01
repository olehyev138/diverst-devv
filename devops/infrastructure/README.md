This is a terraform script describing current AWS infrastructure.

In order to start, put AWS credentials into `secret.auto.tfvars` file:

    access_key = "AWS_ACCESS_KEY_HERE"
    secret_key = "AWS_SECRET_KEY_HERE"

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
