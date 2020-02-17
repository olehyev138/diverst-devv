# Environment Initialization Playbook

Run this playbook to initialize a new environment

## Cloud Infrastructure

##### Environment account documentation

Create a new _secure note_ in our password manager, under `aws-environments`, throughout this document various pieces of information will need to be recorded in here.

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
  
- _Never_ input tag options or notifications.

- Review & launch. Monitor account status until it says _Available_

- SSO Configuration
  
  - Switch SSO roles to administrator account with SSO & IAM permissions
  - Disable the SSO user created for this new account
  - Remove new SSO user from new account
  - Assign current user/group (TODO) to new account
  - Record the _account id_ of the new environment account.
  
- IAM Full Access Role Creation

  - Switch SSO roles to administrative access in new environment account
  - Navigate to IAM & create new role.
  - Select _Another AWS Account_ for trusted entity, copy paste master account ID into text box
  - Select AdministratorAccess for policy
  - Name the role: `cli-bot-<account-name>-administrator-access`
  - Click _Create Role_
  - Increase max role duration to 4 hours
  - Record the role _arn_
  
- IAM Role Policy

  - Switch roles back to master account & navigate into IAM
  - Select _cli-users_ group & create a new _inline policy_  
  - Use _policy_ generator
    - Effect: _Allow_
    - AWS Service: _AWS Security Token Service_
    - Actions: _AssumeRole_
    - ARN: Paste role arn previously written down
  - Click through & apply new policy
  
##### Authentication & Region

- Retrieve AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY values for `cli-bot` from password manager & export into terminal

- Run script `./cli-assume-role <role-arn>`, passing it the role arn from our password manager. Export the outputted values into the appropriate environment variables.

- Ensure that either `AWS_DEFAULT_REGION` is set as an environment variable in `AWS_DEFAULT_REGION` or defined in `~/.aws/config` under `default`. 

- Record the region code

- Ensure following commands are run in the same terminal to make use of environment variables

##### Base resources

- Run script `boostrap-backend`: `./devops/scripts/devops/scripts/bootstrap-backend <env-name>`. Record the name as `master_bucket`.

- Create ssh key pair: `ssh-keygen -qt rsa -N '' -f ~/.ssh/<env-name>`

- Upload public & private key files as attachments in the secure note
                      
##### Create new environment module

- Copy skeleton: `cp -r docs/devops/skeletons/tf-env-skeleton devops/terraform/envs/prod/<env-name>`

- Rename `tfvars` file: `mv devops/terraform/envs/prod/<env-name>/env.tfvars devops/terraform/envs/prod/<env-name>/<env-name>.tfvars`

- Fill out values in files marked with `<>` inside `main.tf` & `<env>.tfvars`

- Ensure the `region` variable in `<env>.tfvars` is set correctly & matches what is set in `AWS_DEFAULT_REGION` & what was recorded in the secure note.

##### Run Terraform

- Change directory into the new environment module

- Initialize terraform: `terraform init`

- Run terraform with the `tfvars` file: `terraform apply -var-file=<env-name>.tfvars`

- Record the outputted values

## Database

- Run the `deployment` playbook

- Run script `init-db`: `./devops/scripts/init-db <bastion-url> <eb-url> <key-path>`

## DNS

- Create two CNAME records pointing to the backend & frontend endpoints respectively.

- Name them with the following naming standards:

- Backend: api-<env_name>-diverst.com
- Frontend: <env_name>-diverst.com
