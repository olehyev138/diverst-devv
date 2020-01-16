# Environment Initialization

## TODO:

- Playbook: Define a well defined list of steps with commands that can be copy and pasted to minimize user error

## Overview

Here we will describe the process for initializing a new environment, from nothing to a working application

Because Diverst is a _single tenant_ application, initialization of new environments is something that will be done semi frequently and thus is a process that needs to be robust, well defined & well documented.

The goal of this document is _not_ to outline, explain the existing infrastructure setup. But how to make use of it to initialize a new production/client environment. Some of this document may overlap somewhat with the `deployment` document which explains how to deploy `diverst` to an initialized environment. 

Setting up a new environment involves three general steps:

1) Creating the cloud infrastructure
2) Initializing the backend
3) Initializing the frontend

## 1) Cloud Infrastructure

Our infrastructure is mostly defined as IAC in Terraform. Each client environment is a module, based off of the `base_prod` module. The terraform code that needs to be written for a new client environment is the configuration properties specific to the client, filling in details for remote state configuration and details for authenticating with AWS.

In addition to IAC, we have a few key pieces globally & per client that need to be created manually, ie through scripts. This includes the account & IAM roles, policies as well as the S3 & dynamo tables needed for Terraform remote state.

Note: As we develop on our devops the goal will be 1) to automate more, as well as manage as much as we can with IAC. 

##### A) Creating client environment account, IAM role & policies

# TODO: - write script to automate this

##### B) Bootstrapping backend for Terraform

Terraform requires a few pieces of infrastructure to already exist in order to function. We creating these manually with the script `bootstrap-backend`

##### C) Creating new Terraform environment module

- Create a new client environment terraform module, by copying from `docs/devops/skeletons/client-env-skeleton`

`cp -r docs/devops/skeletons/client-env-skeleton devops/terraform/envs/prod/<client-name>` 

`mv devops/terraform/envs/prod/<client-name>/client.tfvars devops/terraform/envs/prod/<client-name>/<client-name>.tfvars`

- Fill out the properties `<client-name>.tfvars` & `main.tf` with the values from the previous steps


## 2) Backend

Initializing the backend involves:

 - Running an initial deploy
 - Initializing & seeding the database

!! WIP/TODO:

- Define deployment steps - reference separate deployment document
- Define using (arguments) database initialization script

## 3) Frontend

Frontend does not need any special initialization beyond running an initial deployment

