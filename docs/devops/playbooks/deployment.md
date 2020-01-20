# Deployment Initialization Playbook

## Backend

##### Create application version

- Run `create-app-version`: `./devops/scripts/create-app-version <aws-profile> <eb-app-name> <app-version-label> <bucket-name>`

##### Deploy application version

- Run `deploy-app-version`: `./devops/scripts/deploy-app-version <aws-profile> <eb-env-name> <app-version-label>`

## Frontend

- Run `deploy-frontend`: `./devops/scripts/create-app-version <aws-profile> <frontend-bucket>`
