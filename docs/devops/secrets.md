## Secret's Management

Diverst AWS environments make use of several _secrets_, ie database usernames & passwords, API keys for multiple services. Because these we are secrets we cannot store them in the `.tfvars` file as usual. 

To securely store this information we make use of the cli tool `chamber`. Chamber stores keys in AWS Parameter key store and on execution loads them into environment variables for use by Terraform. Additionally, Chamber uses KMS to encrypt the secrets. We use a Terraform `kms` module to create these necessary resources.

##### Workflow 

###### Initialization

- Will be described additionally in the environment initialization documents

- After Terraform has created the new environments, we manually add the necessary secrets to chamber. 

- The command to add a secret to the parameter key store with chamber is as follows:


!!!! _TODO_: write out command for copy/paste !!!!

```
chamber write terraform <variable_name> <secret>
```

###### General usage

- Instead of running just `terraform apply` now, we will wrap this in a call to `chamber`, which will load our secrets into environment variables.

- Additionally, because we need the environment variables in a specific format so that Terraform will pick them up, we make use of a script `tf-chamber-format` to act as an intermediary and format the output of `chamber` for Terraform usage. 

- The general command to apply a Terraform plan is as follows:

```
../../../../scripts/tf-chamber-format terraform apply --var-file devops.tfvars  
```

