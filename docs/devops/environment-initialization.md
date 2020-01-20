# Environment Initialization

## Overview

Here we will describe the process for initializing a new environment, from nothing to a working application

Because Diverst is a _single tenant_ application, initialization of new environments is something that will be done semi frequently and thus is a process that needs to be robust, well defined & well documented.

The goal of this document is _not_ to outline, explain the existing infrastructure setup. But how to make use of it to initialize a new production/client environment. 

Setting up a new environment involves two general steps:

1) Creating the cloud infrastructure
2) Initializing the database

## 1) Cloud Infrastructure

Our infrastructure is mostly defined as IAC with Terraform. Each client environment is a module, based off of the `base_prod` module. The terraform code that needs to be written for a new client environment is the configuration properties specific to the client, filling in details for remote state configuration and details for authenticating with AWS.

In addition to IAC, we have a few key resources that need to be created manually/through scripts. This includes the account, IAM role & policies and the S3 & dynamo table needed for Terraform remote state.

_Note_: As we develop on our devops, the goal will be 1) to automate more, as well as manage as much as we can with IAC. 

#### A) Creating client environment account, IAM role & policies

_TODO_

#### B) Bootstrapping backend for Terraform

Terraform requires a few pieces of infrastructure to already exist in order to function. We create these manually with the script `bootstrap-backend`

Run the script `boostrap-backend` as follows.

- `aws-profile` is the profile from the previous step, defined in your credentials file that uses role assumption to allow access to the client account.

`./devops/scripts/bootstrap-backend <aws-profile> <client-name>`

This will create a bucket to store Terraform state & a dynamo table for state locking. The values outputted by the script will be what you will fill in, in the Terraform configuration, defined in the following step.

The other resource that must exist before running Terraform is a SSH key pair. To create a SSH key pair run

`ssh-keygen -qt rsa -N '' -f ~/.ssh/<client-name>`

Terraform will import this key pair into AWS & use it to allow authentication with the bastion & EB servers.

_TODO: define workflow for adding key to password manager_

#### C) Creating a new Terraform environment module

Create a new client environment terraform module, by copying from `docs/devops/skeletons/client-env-skeleton`

`cp -r docs/devops/skeletons/client-env-skeleton devops/terraform/envs/prod/<client-name>` 

`mv devops/terraform/envs/prod/<client-name>/client.tfvars devops/terraform/envs/prod/<client-name>/<client-name>.tfvars`

Fill out the properties `<client-name>.tfvars` & `main.tf` with the values from the previous steps

#### D) Run Terraform

To run terraform, one simply needs to `cd` into the new environment module, initialize and run terraform, passing it the `tfvars` file.

`terraform init` is idempotent and is safe to run anytime.

- `terraform init`

- `terraform apply -var-file='<client-name>.tfvars`

## 2) Database initialization

For a client/environment with new infrastructure, the database must be initalized.

Before initializing, first follow the steps in the `deployment` document in order to run the initial deployment.

The app will _not_ be accessible after, but the deployment will complete successfully.

Once the deployment is run, we can initialize the database, which is done by running the `init-db` script.

To initialize the the database, run the `init-db` script as follows:

- `bastion-url` - The _public_ IP of the bastion host - outputted by Terraform.

- `eb-url` - The _private_ IP of one of the ec2 hosts, managed by Elastic Beanstalk - outputted by Terraform.

- `key-path` - The path for the ssh key to authenticate.

`./init-db <bastion-url> <eb-url> <key-path>`

The application should now be fully functioning.
