# Deployment Playbook

- All values required for commands are found in the secure note for the corresponding environment account.

#### Authentication & Region

- Retrieve `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` values for `cli-bot` from password manager & export into terminal

- Retrieve cli access role ARN for new environment account

- Run script `eval $(./cli-assume-role <role-arn>)`

- Ensure that either `AWS_DEFAULT_REGION` is set as an environment variable in `AWS_DEFAULT_REGION` and that it matches the value recorded in the secure note.

- Ensure following commands are run in the same terminal to make use of environment variables

## Backend

##### Create application version

- Run `create-app-version`: `./devops/scripts/create-app-version <env-name> <app-version-label> <master-bucket-name>`

##### Deploy application version

- Run `deploy-app-version`: `./devops/scripts/deploy-app-version <env-name> <app-version-label>`

## Frontend

- Run `deploy-frontend`: `./devops/scripts/create-app-version <frontend-bucket>`
