# Environment Initialization Playbook

Run this playbook to initialize a new environment

## Cloud Infrastructure

##### Environment account & IAM resources

- Log into AWS through SSO & access the _AWSServiceCatalogueEndUserAccess_ role/permission set under the Master account.

- Navigate to AWS Service Catalog, under Products List you will see _AWS Control Tower Account Factory_. Click into it & click _Launch Product_.

- Click through & fill in the fields as follows:

  - _Name_: environment/client name -
  - _SSOUserEmail_: `aws+<env-name>@diverst.com`
  - _SSOAccountEmail_: `aws+<env-name>@diverst.com`
  - _SSOUserFirstName_: `env-name` - lower case
  - _SSOUserLastName_: `production` or `development`
  - _OU_: `ProductionEnvironments` or `DevelopmentEnvironments`
  - _Account Name_: Environment/client name, capital case
  
- Never input tag options or notifications, AWS Control Tower handles this for us and setting these can cause Account Factory to fail.

- Review & launch. Monitor the status of the account under _Provisioned Product List_ to ensure that the account has been created & provisioned correctly. Monitor it until the status says _Available_

- Lastly, switch roles/permission sets to an administrator that access SSO. Disable the SSO user created for this new account and assign the group _production_ to the new environment account with full administrative permissions.

##### Authentication & Region

- Set AWS keys & tokens by authenticating with `iac-bot` & copying the environment variable export commands into your terminal.

- Ensure that either `AWS_DEFAULT_REGION` is set as an environment variable in `AWS_DEFAULT_REGION` or defined in `~/.aws/config` under `default`. 

##### Base resources

- Login to the SSO console with the special user _iac-bot_, select the new environment account, select command line, copy the environment variable export commands into the terminal.

- Run script `boostrap-backend`: `./devops/scripts/devops/scripts/bootstrap-backend <env-name>`. Note the name of the bucket printed out.

- Create ssh key pair: `ssh-keygen -qt rsa -N '' -f ~/.ssh/<env-name>`
                      
##### Create new environment module

- Copy skeleton: `cp -r docs/devops/skeletons/tf-env-skeleton devops/terraform/envs/prod/<env-name>`

- Rename `tfvars` file: `mv devops/terraform/envs/prod/<env-name>/env.tfvars devops/terraform/envs/prod/<env-name>/<env-name>.tfvars`

- Fill out values in files marked with `<>` inside `main.tf` & `<env>.tfvars`

- Ensure the `region` variable in `<env>.tfvars` is set correctly & matches what is set in `AWS_DEFAULT_REGION`  or defined in `~/.aws/config` under `default`. 

##### Run Terraform

- Change directory into the new environment module

- Initialize terraform: `terraform init`

- Run terraform with the `tfvars` file: `terraform apply -var-file=<env-name>.tfvars`

## Database

- Run the `deployment` playbook

- Run script `init-db`: `./devops/scripts/init-db <bastion-url> <eb-url> <key-path>`
