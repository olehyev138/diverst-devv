# Deployment

## General deployment

Describes deployment in general, ie on any machine and not specific to CI processes. 

Assumes fully initialized & working infrastructure.

### Backend

The Diverst application backend is managed through AWS Elastic Beanstalk. For deployment specifics with Elastic Beanstalk refer to AWS documentation.

Backend deployment consists of two steps

1) Creating a new application version.
2) Deploying the new application version.

#### Creating a new application version

Creating a new `application version` consists of:

- Zipping the backend into an `application bundle`
- Uploading the application bundle to the clients _master s3 bucket_
- Creating a new `application version` in Elastic Beanstalk, which points to the previous uploaded `application bundle`

This process is automated through the `create-app-version` script. 

To create a new app version, run the `create-app-version` script as follows. It is required that the working directory is the app root.

- `aws-profile` is how we authenticate with AWS. This should be defined in your credentials file and should assume the role in the environment account. 

- `eb-app-name` is the application name, _not_ the environment name. This should be the same as the client/environment name.

- `app-version-label` is a label identifying this app version.

- `bucket-name` is the bucket where we store app versions. This is the same bucket where we store Terraform state. This is created in the `environment-initialization` process. 

`./create-app-version <aws-profile> <eb-app-name> <app-version-label> <bucket-name>`

_Todo: Workflow needs to be defined for versioning_

#### Deploying an application version

Deploying an application version simply consists of making an API call to Elastic Beanstalk telling it to deploy a given application version. Elastic Beanstalk will then handle tearing down and spinning up new servers with the new version.

This process is automated through the `deploy-app-version` script

To deploy a given application version, run the `deploy-app-version` script as follows:

- `aws-profile` is how we authenticate with AWS. This should be defined in your credentials file and should assume the role in the environment account.

- `eb-app-name` is the environment name, _not_ the application name. This should be in the form `<client-name>-env`

- `app-version-label` is the label of the app version that we want to deploy.

`./deploy-app-version <aws-profile> <eb-env-name> <app-version-label>`

### Frontend

The Diverst frontend is a React application hosted statically through S3.

Terraform manages & creates a bucket for static web hosting with a name in the form: `<client-name>-frontend-<random-postfix`

We use a random postfix to avoid name conflicts, as S3 operates in a global namespace.

To deploy the frontend, we simply need to build the frontend and then upload it to the S3 bucket. This process is managed & automated with the `deploy-frontend` script.

To deploy the frontend, run the `deploy-frontend` script as follows: 

- `aws-profile` is how we authenticate with AWS. This should be defined in your credentials file and should assume the role in the environment account.

- `frontend-bucket` - name of the frontend bucket created by Terraform.

`./create-app-version <aws-profile> <frontend-bucket>`
