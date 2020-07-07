## Secret's Management

Diverst AWS environments make use of several _secrets_, ie database usernames & passwords, API keys for multiple services. Because these we are secrets we cannot store them in the `.tfvars` file as usual. 

To securely store this information we make use of the cli tool `chamber`. Chamber stores keys in AWS Parameter key store and on execution loads them into environment variables for use by Terraform. Additionally, Chamber uses KMS to encrypt the secrets. We use the `bootstrap-backend` script to accomplish this. We use the script because this is a resource that we need in order to use Terraform.

##### Workflow 

###### Initialization

- Will be described additionally in the environment initialization documents

- _Before_ Terraform has created the new environments, we manually add the necessary secrets to chamber. Further down we describe a list of secrets that the Diverst environments make use of. And must be added in order to initialize a new environment with Terraform.

- Secrets are _never_ added to the `<env>.tfvars` file and are never put under version control in any manner. We write them manually to the parameter key store for the specific environment account using chamber, and upon launching of Terraform, chamber loads them into environment variables for use by the current shell session only.

- The command to add a secret to the parameter key store with chamber is as follows:

```
chamber write terraform <variable_name> <secret>
```

###### General usage

- Instead of running just `terraform apply` now, we will wrap this in a call to `chamber`, which will load our secrets into environment variables.

- Additionally, because we need the environment variables in a specific format so that Terraform will pick them up, we make use of a script `tf-chamber-format` to act as an intermediary and format the output of `chamber` for Terraform usage. 

- The general command to apply a Terraform plan is as follows:

```
../../../../scripts/tf-chamber-format terraform apply --var-file <env-name>.tfvars  
```

##### Diverst Secrets 

Here we will list the secrets used by the Diverst environments and the mandatory format they must written to the parameter key store in, in order for Terraform to pick them up.

- Rails Master Key

Format: `rails_master_key`

- Database Password

Format: `db_password`

- Sidekiq Password

Format: `sidekiq_password`

- Mailgun API Key

Format: `mailgun_api_key`

- Rollbar Access Token

Format: `rollbar_access_token`

- Embedly Key

Format: `embedly_key`
