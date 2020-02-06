# Deployment Playbook

#### Authentication & Region

- Set AWS keys & tokens by authenticating with `iac-bot` & copying the environment variable export commands into your terminal.

- Ensure that either `AWS_DEFAULT_REGION` is set as an environment variable or defined in `~/.aws/config` under `default`. 

## Backend

##### Create application version

- Run `create-app-version`: `./devops/scripts/create-app-version <eb-app-name> <app-version-label> <bucket-name>`

##### Deploy application version

- Run `deploy-app-version`: `./devops/scripts/deploy-app-version <eb-env-name> <app-version-label>`

## Frontend

- Run `deploy-frontend`: `./devops/scripts/create-app-version <frontend-bucket>`
