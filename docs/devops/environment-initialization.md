# Environment Initialization

## Overview

Here we will describe the process for initializing a new environment, from nothing to a working application

Because Diverst is a _single tenant_ application, initialization of new environments is something that will be done semi frequently and thus is a process that needs to be robust, well defined & well documented.

The goal of this document is _not_ to outline, explain the existing infrastructure setup. But how to make use of it to initialize a new environment account.

Setting up a new environment involves two general steps:

1) Creating the cloud infrastructure
2) Initializing the database


## 1) Cloud Infrastructure

Our infrastructure is mostly defined as IAC with Terraform. Each environment account is a module, based off of the `base_prod` module. The terraform code that needs to be written for a new environment account is the configuration properties specific to the environment, filling in details for remote state configuration and details for authenticating with AWS.

In addition to IAC, we have a few key resources that need to be created manually/through scripts. This includes only at the moment - a S3 bucket & dynamo table needed for Terraform remote state.

_Note_: As we develop on our devops, the goal will be 1) to automate more, as well as manage as much as we can with IAC. 

#### A) Creating an environment account

The first step in initializing a new environment is setting up a _environment account_ for the infrastructure to live in. 

This process currently has to be done manually through the AWS web console. Your user requires the _AWSServiceCatalogueEndUserAccess_ permission set.

- Log into AWS through SSO & access the _AWSServiceCatalogueEndUserAccess_ role/permission set under the Master account.

- Navigate to AWS Service Catalog, under Products List you will see _AWS Control Tower Account Factory_. Click into it & click _Launch Product_.

- Under name, input the name of the environment. If you are setting up a new client, this should be the name of the client, click next.

- Under _SSOUserEmail_ as well as _AccountEmail_, input `aws+<env-name>@diverst.com`, ie `aws+testing@diverst.com` is the email for our testing environment account.

- For _SSOUserFirstName_, input `<env-name>`, lowercase, ie _testing_. For _SSOUserLastName_, input _production_ if this is a client environment account, or _development_ if it is a testing, development environment.

- For the OU, select ProductionEnvironments for client environments or DevelopmentEnvironments otherwise.

- Lastly, for AccountName, write the client/environment name with capital casing, ie _Testing_

- Never input tag options or notifications, AWS Control Tower handles this for us and setting these can cause Account Factory to fail.

- Review & launch. Monitor the status of the account under _Provisioned Product List_ to ensure that the account has been created & provisioned correctly. It will say _Under change_ for a while, it should eventually change to _Available_

- Lastly, switch roles/permission sets to an administrator that access SSO. Disable the SSO user created for this new account and assign the group _production_ to the new environment account with full administrative permissions.

### B) Authentication & Region

Before proceeding we must set the AWS keys & session tokens to authenticate with the new environment account, as well as the region to use. 

To set the keys, in your web browser, authenticate with the special user `iac-user` in the SSO portal. Select the appropriate environment account then copy the environment variable export commands to set the AWS keys & tokens.

For the region, ensure that either `AWS_DEFAULT_REGION` is set as an environment variable or defined in `~/.aws/config` under `default`. 

#### C) Bootstrapping backend for Terraform

Terraform requires a few pieces of infrastructure to already exist in order to function. We create these manually with the script `bootstrap-backend`

Now Run the script `boostrap-backend` as follows.

`./bootstrap-backend <env-name>`

Note the name of the state bucket the script outputs.

This will create a bucket to store Terraform state & a dynamo table for state locking. The values outputted by the script will be what you will fill in, in the Terraform configuration, defined in the following step.

The other resource that must exist before running Terraform is a SSH key pair. To create a SSH key pair run

`ssh-keygen -qt rsa -N '' -f ~/.ssh/<env-name>`

Terraform will import this key pair into AWS & use it to allow authentication with the bastion & EB servers.

_TODO: define workflow for adding key to password manager_

#### D) Creating a new Terraform environment module

Create a new environment terraform module, by copying from `docs/devops/skeletons/tf-env-skeleton`

`cp -r docs/devops/skeletons/tf-env-skeleton devops/terraform/envs/prod/<env-name>` 

Rename the environment variable file to match the environment name

`mv devops/terraform/envs/prod/<env-name>/env.tfvars devops/terraform/envs/prod/<environment-name>/<env-name>.tfvars`

Fill out the properties in `<env-name>.tfvars` & `main.tf` with the values from the previous steps

In `<env-name>.tfvars`, fill in the variables. In `main.tf`, fill in the name of the state bucket from the last step. Set the dynamo lock table name & fill in the path of the ssh key created in the last step.

Ensure the `region` variable in `<env>.tfvars` is set correctly & matches what is set in `AWS_DEFAULT_REGION`  or defined in `~/.aws/config` under `default`. 

#### E) Run Terraform

To run terraform, one simply needs to `cd` into the new environment module, initialize and run terraform, passing it the `tfvars` file.

`terraform init` is idempotent and is safe to run anytime.

- `terraform init`

- `terraform apply -var-file='<env-name>.tfvars`

## 2) Database initialization

For a environment with new infrastructure, the database must be initialized.

Before initializing, first follow the steps in the `deployment` document in order to run the initial deployment.

The app will _not_ be accessible after, but the deployment will complete successfully.

Once the deployment is run, we can initialize the database, which is done by running the `init-db` script.

To initialize the the database, run the `init-db` script as follows:

- `bastion-url` - The _public_ IP of the bastion host - outputted by Terraform.

- `eb-url` - The _private_ IP of one of the ec2 hosts, managed by Elastic Beanstalk - outputted by Terraform.

- `key-path` - The path for the ssh key to authenticate.

`./init-db <bastion-url> <eb-url> <key-path>`

The application should now be fully functioning.
