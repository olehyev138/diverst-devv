# Environment Initialization

## TODO:

- Playbook: Define a well defined list of steps with commands that can be copy and pasted to minimize user error

## Overview

Here we will describe the process for initializing a new environment, from nothing to a working application

Because Diverst is a _single tenant_ application, initialization of new environments is something that will be done semi frequently and thus is a process that needs to be robust, well defined & well documented.

## 1) Infrastructure

Our infrastructure is defined as IAC in Terraform. Each client environment is a module, based off of the `base_prod` module.

!! WIP/TODO:

- Define steps/playbook to initialize terraform backend (state bucket, dynamo table, account)
- Define steps for creating a new client module
- Define a skeleton/template client module (`main.tf` & `variables.tf`)

## 2) Backend

Initializing the backend involves:

 - Running an initial deploy
 - Initializing & seeding the database

!! WIP/TODO:

- Define deployment steps - reference separate deployment document
- Define using (arguments) database initialization script

## 3) Frontend

Frontend does not need any special initialization beyond running an initial deployment

