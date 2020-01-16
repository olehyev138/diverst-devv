# Environment Initialization Playbook

_Run_ this playbook to initialize a new client environment

## Cloud Infrastructure

##### Environment account & IAM resources

_TODO_

##### Base resources

- Run script `boostrap-backend`: `./devops/scripts/bootstrap-backend <aws-profile> <client-name>`

- Create ssh keypair: `ssh-keygen -qt rsa -N '' -f ~/.ssh/<client-name>`
                      
##### Create new environment module

- Copy skeleton: `cp -r docs/devops/skeletons/client-env-skeleton devops/terraform/envs/prod/<client-name>`

- Rename `tfvars` file: `mv devops/terraform/envs/prod/<client-name>/client.tfvars devops/terraform/envs/prod/<client-name>/<client-name>.tfvars`

- Fill out values in files marked with `<>`

##### Run Terraform

- Run terraform with the `tfvars` file: `terraform apply -var-file='<client-name>.tfvars`

## Database

- Run the `deployment` playbook

- Run script `init-db`: `./init-db <bastion-url> <eb-url> <key-path>`
