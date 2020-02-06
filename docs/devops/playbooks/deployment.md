# Deployment Playbook

#### Authentication & Region

- Retrieve AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY values for `cli-bot` from password manager & export into terminal

- Retrieve cli access role ARN for new environment account

- Run script `. ./cli-assume-role <role-arn>` - ensure it is done verbatim to allow script to export environment variables

- Ensure that either `AWS_DEFAULT_REGION` is set as an environment variable in `AWS_DEFAULT_REGION` or defined in `~/.aws/config` under `default`. 

- Ensure following commands are run in the same terminal to make use of environment variables

- Ensure that either `AWS_DEFAULT_REGION` is set as an environment variable or defined in `~/.aws/config` under `default`. 

## Backend

##### Create application version

- Run `create-app-version`: `./devops/scripts/create-app-version <eb-app-name> <app-version-label> <bucket-name>`

##### Deploy application version

- Run `deploy-app-version`: `./devops/scripts/deploy-app-version <eb-env-name> <app-version-label>`

## Frontend

- Run `deploy-frontend`: `./devops/scripts/create-app-version <frontend-bucket>`
