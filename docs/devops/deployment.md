# Deployment

Describes deployment in general, ie on any machine and not specific to CI/CD processes. 

Assumes fully initialized & working infrastructure.

### Precursors - Authentication & Region

Because we authenticate through role assumption with the IAM user `cli-bot`, we need to retrieve the aws key id, secret access key & temporary session token. With these 3 values set as environment variables our scripts & iac tools (terraform) will be able to authenticate with the environment account

First retrieve AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY values for `cli-bot` from password manager & export into terminal. These are specifically for the cli-bot & will be reset for the new environment account by our script.

Run script `eval $(./cli-assume-role <role-arn>)`, passing it the role arn from the password manager. 

Lastly, ensure that either `AWS_DEFAULT_REGION` is set as an environment variable in `AWS_DEFAULT_REGION`. Ensure that it matches the value recorded in the secure note.

Ensure all of the following commands are run in the same terminal to make use of environment variables, otherwise scripts & iac tools will not be able to authenticate. If the terminal is closed or changed, this step must be rerun.

### Backend

The Diverst application backend is managed through AWS Elastic Beanstalk. For deployment specifics with Elastic Beanstalk refer to AWS documentation.

Backend deployment consists of two steps

1) Creating a new application version.
2) Deploying the new application version.

#### Creating a new application version

Creating a new `application version` consists of:

- Zipping the backend into an `application bundle`
- Uploading the application bundle to the environments _master s3 bucket_
- Creating a new `application version` in Elastic Beanstalk, which points to the previous uploaded `application bundle`

This process is automated through the `create-app-version` script. 

To create a new app version, run the `create-app-version` script as follows. It is required that the working directory is the app root.

- `env-name` - the environment account name, ie `testing` or `kp`.

- `app-version-label` is a label identifying this app version.

- `bucket-name` is the bucket where we store app versions. This is the same bucket where we store Terraform state. This is created in the `environment-initialization` process and stored in the secure note for the environment account.

`./create-app-version <env-name> <app-version-label> <master-bucket-name>`

_Todo: Workflow needs to be defined for versioning_

#### Deploying an application version

Deploying an application version simply consists of making an API call to Elastic Beanstalk telling it to deploy a given application version. Elastic Beanstalk will then handle tearing down and spinning up new servers with the new version.

This process is automated through the `deploy-app-version` script

To deploy a given application version, run the `deploy-app-version` script as follows:
 
- `env-name` - the environment account name, ie `testing` or `kp`.

- `app-version-label` is the label of the app version that we want to deploy.

`./deploy-app-version <env-name> <app-version-label>`

### Frontend

The Diverst frontend is a React application hosted statically through S3.

Terraform manages & creates a bucket for static web hosting with a name in the form: `<env-name>-frontend-<random-postfix`. The name is recorded in the secure note.

To deploy the frontend, we simply need to build the frontend and then upload it to the S3 bucket. This process is managed & automated with the `deploy-frontend` script.

To deploy the frontend, run the `deploy-frontend` script as follows: 

- `frontend-bucket` - name of the frontend bucket created by Terraform.

`./deploy-frontend <frontend-bucket>`

### Analytics

_TODO_
