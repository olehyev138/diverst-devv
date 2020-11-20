# Environment Initialization

## Overview

Here we will describe the process for initializing a new environment, from nothing to a working application

Because Diverst is a _single tenant_ application, initialization of new environments is something that will be done semi frequently and thus is a process that needs to be robust, well defined & well documented.

The goal of this document is _not_ to outline, explain the existing infrastructure setup, but to explain how to make use of it to initialize a new environment account.

Setting up a new environment involves two general steps, as well as DNS setup:

1) Creating the cloud infrastructure
2) Initializing the database
3) DNS setup

## Environment account documentation

We make use of our password manager to keep track & store general bits of unique information for each environment account. 

Before starting, create a new _secure note_ inside our password manager under the `aws-environments` collection. Throughout this process, we will mention when to record a piece of information for future usage. When this happens, create a new custom field and copy the value in. Some steps may require information recorded in previous steps, or it will be needed for deployment, or possible maintenance in the future. 

## 1) Cloud Infrastructure

Our infrastructure is mostly defined as IAC with Terraform. Each environment account is a module, based off of the `base_prod` module. The terraform code that needs to be written for a new environment account is the configuration properties specific to the environment, filling in details for remote state configuration and details for authenticating with AWS.

In addition to IAC, we have a few key resources that need to be created manually/through scripts. This includes only at the moment - a S3 bucket, a dynamo table needed for Terraform remote state, a KMS key for secrets management & Parameter Key Store entries. 

_Note_: As we develop on our devops, the goal will be 1) to automate more, as well as manage as much as we can with IAC. 

#### A) Creating an environment account

The first step in initializing a new environment is setting up a _environment account_ for the infrastructure to live in. 

This process currently has to be done manually through the AWS web console.

- Log into AWS through SSO & access the _AWSServiceCatalogueEndUserAccess_ role/permission set under the Master account.

- Navigate to AWS Service Catalog, under Products List you will see _AWS Control Tower Account Factory_. Click into it & click _Launch Product_.

- Under name, input the name of the environment. If you are setting up a new client, this should be the name of the client, click next.

- Under _SSOUserEmail_ as well as _AccountEmail_, input `aws+<env-name>@diverst.com`, ie `aws+testing@diverst.com` is the email for our testing environment account.

- For _SSOUserFirstName_, input `<env-name>`, lowercase, ie _testing_. For _SSOUserLastName_, input _production_ if this is a client environment account, or _development_ if it is a testing, development environment.

- For the OU, select ProductionEnvironments for client environments or DevelopmentEnvironments otherwise.

- Lastly, for AccountName, write the client/environment name with capital casing, ie _Testing_

- Never input tag options or notifications, AWS Control Tower handles this for us and setting these can cause Account Factory to fail.

- Review & launch. Monitor the status of the account under _Provisioned Product List_ to ensure that the account has been created & provisioned correctly. It will say _Under change_ for a while, it should eventually change to _Available_

Now that we have a provisioned environment account, we have to setup a role inside &  a policy in the master account to allow the special user `cli-bot` access. This a very manual process and in the future may be automated through CloudFormation stack sets.

- SSO Configuration
  
  - Switch SSO roles to administrator account with SSO & IAM permissions
  - Disable the SSO user created for this new account
  - Remove new SSO user from new account
  - Assign current _EnvironmentAdmins_ group to new account with _AWSAdministratorAccess_ permission set
  - Record _account id_ of new environment account
  
- IAM Administrator Access Role Creation

  - Switch SSO roles to administrative access in new environment account
  - Navigate to IAM & create new role.
  - Select _Another AWS Account_ for trusted entity, copy paste master account ID into text box - consult password manager for id.
  - Select AdministratorAccess for policy
  - Name the role: `cli-users-<account-name>-administrator-access`
  - Click _Create Role_
  - Increase max role duration to 4 hours
  - Record _role arn_
  
- IAM Role Policy

  - Switch roles back to master account & navigate into IAM
  - Select _cli-users_ group & create a new _inline policy_  
  - Use _policy_ generator
    - Effect: _Allow_
    - AWS Service: _AWS Security Token Service_
    - Actions: _AssumeRole_
    - ARN: Paste role arn previously recorded
  - Click through & apply new policy. Name policy: `cli-users-allow-<account>-administrator-access`
  
### B) Authentication & Region

Because we authenticate through role assumption with the IAM user `cli-bot`, we need to retrieve the aws key id, secret access key & temporary session token. With these 3 values set as environment variables our scripts & iac tools will be able to authenticate with the environment account

First retrieve `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` values for `cli-bot` from the password manager & export into terminal. These are specifically for the `cli-bot` & will be reset for the new environment account by our script.

Run script `eval $(./cli-assume-role <role-arn>)`, passing it the role arn. Its done this way so that we can export the variables in the current shell & not a subshell

Lastly, ensure that either `AWS_DEFAULT_REGION` is set as an environment variable in `AWS_DEFAULT_REGION` or defined in `~/.aws/config` under `default`.

Record the region code (ie `us-east-1`).

Test cli authentication has been setup right by running

`aws iam list-roles` - you should see in the output, the role you created in the previous steps.

Ensure all of the following commands are run in the same terminal to make use of environment variables, otherwise scripts & iac tools will not be able to authenticate. If the terminal is closed or changed, this step must be rerun.

#### C) Bootstrapping backend for Terraform

Terraform requires a few pieces of infrastructure to already exist in order to function. We create these manually with the script `bootstrap-backend`. It is important to note that these resources are created manually via the aws cli tool and therefore not managed by Terraform. These resources are necessary for Terraform to function, therefore they must exist _before_ Terraform is run. To be specific, the _bootstrapped_ resources are the following:

- A _master S3 bucket_ - this is where the Terraform state lives, as well as our backend deployment bundles. 
- A _dynamodb table_ - Terraform uses this to perform locking on the state file
- A _kms key_ & entries in the _parameter key store_ - used for secrets management. These secrets are loaded into Terraform upon run, therefore they must exist beforehand. Consult the secrets management document for more information.

To create these resources, run the script `boostrap-backend` as follows.

`./bootstrap-backend <env-name>`

Record the name of the state bucket the script outputs. This is our _master bucket_ for the environment account and is where Terraform will store its state and we will store backend app version bundles.

This will create a bucket to store Terraform state, a dynamo table for state locking & a KMS key for secrets management. The values outputted by the script will be what you will fill in, in the Terraform configuration, defined in the following step.

The other resource that must exist before running Terraform is a SSH key pair. To create a SSH key pair run

`ssh-keygen -qt rsa -N '' -f ~/.ssh/<env-name>`

Terraform will import this key pair into AWS & use it to allow authentication with the bastion & EB servers.

Upload both the public & private key files as attachments to the secure note.

Lastly, before proceeding, refer to the `secrets` document to write out the secrets to the parameter key store. These secrets will be passed to Terraform via environment variables. This will consist of passwords & API keys. The passwords should be auto generated and the API keys will be found in the password manager. Ensure secrets are written in proper format as described in `secrets`, otherwise Terraform will not find them.

#### D) Creating a new Terraform environment module

Create a new environment terraform module, by copying from `docs/devops/skeletons/tf-env-skeleton`

`cp -r docs/devops/skeletons/tf-env-skeleton devops/terraform/envs/prod/<env-name>` 

Rename the environment variable file to match the environment name

`mv devops/terraform/envs/prod/<env-name>/env.tfvars devops/terraform/envs/prod/<environment-name>/<env-name>.tfvars`

Fill out the properties in `<env-name>.tfvars` & `main.tf` with the values from the previous steps

In `<env-name>.tfvars`, fill in the variables. In `main.tf`, fill in the name of the state bucket from the last step. Set the dynamo lock table name & fill in the path of the ssh key created in the last step. Make sure you use the public file, ie `testing.pub`.

Ensure the `region` variable in `<env>.tfvars` is set correctly & matches what is set in `AWS_DEFAULT_REGION` & the secure note.

#### E) Run Terraform

To run terraform, one simply needs to `cd` into the new environment module, initialize and run terraform, passing it the `tfvars` file.

`terraform init` is idempotent and is safe to run anytime.

- `terraform init`

- `../../../../scripts/tf-chamber-format terraform apply --var-file <env-name>.tfvars `

Record the ips & endpoints it outputs in the secure note.

## 2) Database initialization

For a environment with new infrastructure, the database must be initialized.

Before initializing, first follow the steps in the `deployment` document in order to run the initial deployment.

The app will _not_ be accessible after, but the deployment will complete successfully.

Once the deployment is run, we can initialize the database, which is done by running the `init-db` script.

To initialize the the database, run the `init-db` script as follows:

- `bastion-url` - The _public_ IP of the bastion host.

- `eb-url` - The _private_ IP of one of the ec2 hosts, managed by Elastic Beanstalk.

- `key-path` - The path for the ssh key to authenticate.

`./init-db <bastion-url> <eb-url> <key-path>`

The application should now be fully functioning.

## 3) DNS Setup

Finally, we need to create two CNAME records in Cloudflare for our backend & frontend applications.

Each should point to the backend & frontend endpoints respectively. 

For DNS information in general, consult our DNS documentation.

Create the CNAME DNS records with the following naming standards:

- Backend: api-<env_name>-diverst.com
- Frontend: <env_name>-diverst.com

## 4) Parameter Store Entries for Production Deployment 

For automated production deployment we store production environment info in the parameter store in the main/root Diverst account. Entries are organized in the store by environment like `/<env-name>/entry`. Entries are also encrypted via a key in KMS.

We use chamber to write the data to the parameter store. The main `cli-bot` IAM account we use for STS access into the env accounts also has permissions to access the parameter store. Ensure the shell is authenticated with the `cli-bot` account but _not_ a environment account

To write an entry run the command as follows:

```
chamber write <env> <entry_name> <entry_value>
```

The following information in the format as written is required in the store for production environment accounts 

- env 

The environment name for the account, ie `devops`

- frontend_bucket

The name for the S3 bucket serving the frontend application, ie `devops.diverst.com`

- master_bucket

The name for the S3 bucket where we store the backend application bundles, ie `devops-idkdsjsjsjaj`

- role_arn 

The role ARN that the `cli-bot` account uses to authenticate with the environment account