# Deployment

## General deployment

Describes deployment in general, ie on any machine and not specific to CI processes. 

Assumes fully initialized & working infrastructure

### Backend

The Diverst application backend is managed through AWS Elastic Beanstalk. For deployment with Elastic Beanstalk i would refer to AWS documentation.

Generally, deployment consists of two steps

1) Creating a new application version.
2) Deploying the new application version.


##### Creating a new application version

Creating a new `application version` involves zipping the backend into an `application bundle`, uploading the application version to the clients _master s3 bucket_, which also holds the S3 state & finally creating a new `application version` in Elastic Beanstalk, pointing to the new `application bundle`

This process is automated through the `create-app-version` script. 

!! TODO: Document using script
!! NOTE: Proper authenticating with AWS, versioning & zipping of the backend still needs to be implemented

##### Deploying an application version

Deploying an application version simply consists of making an API call to elastic beanstalk telling it to deploy a given application version.

This process is automated through the `deploy-app-version` script

### Frontend

!! TODO

## Continuous Integration

!! TODO
