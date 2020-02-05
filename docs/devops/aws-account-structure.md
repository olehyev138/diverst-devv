# Account Structure, Provisioning & Governance

## Intro

We make use of AWS Organizations for proper isolation, authentication/authorization and auditing. Because Diverst is single tenant, full isolation between environments is of most importance. Additionally, because of the single tenancy model, it is important for us to have a trivial, well defined process for provisioning new environment accounts.

In order to make use of rigorous, secure & scalable state of the art account structures and to ease the overhead involved in doing so, we make use of AWS Control Tower to setup & maintain our organization.

This implies that we will be using AWS's SSO service. This is a more appropriate authentication option for an AWS Organization, as opposed to IAM Users, as IAM is tied to a individual account. With SSO we can easily authorize with many accounts with a single sign on. 

## Overview

Our account structure foundation is what AWS Control Tower sets up with. A _master_, _audit_ & _log_ account.

Additionally, we build off the concept of _environment_ accounts, that a user can access through role assumption.

_Environment accounts_ are accounts that hold a set of infrastructure that make up a instance of the Diverst application.

Environment accounts are meant to be accessed through an IAC tool, in our case - Terraform. They should only ever be accessed manually with _read only_ permissions for auditing.  

Control Tower sets us up with a _Core_ & _Custom_ OU. Under Core, is where the shared accounts - Log & Auditing are located. Additionally we add two OU's for environment accounts, _ProductionEnvironments_ & _DevelopmentEnvironments_. ProductionEnvironments is where all client environment accounts are stored. Under DevelopmentEnvironments is where we will store our testing & staging instances. Lastly, we add a Test OU, where we can spin up any developer test accounts, to perform any miscellaneous development/testing tasks.

Developers authenticate with AWS SSO & access the accounts they have access to. Admins with SSO management permissions _add_ users to various accounts with appropriate permission sets. 

Each environment account is created & provisioned with Account Factory, and thus comes with its own SSO user, this SSO user is disabled as these accounts do not represent individual people. Environment accounts are accessed with the special _iac_ sso user or by auditors who have read only permissions. 

We create a special _iac_ user, that has admin access permissions to the environment accounts. This account is meant to only be used by iac tools. 

#### Group Structure

SSO Groups define roles/jobs in our AWS organization. We then add users to these groups to allow them to perform various functions, such as security auditing, billing or user management and log monitoring.

Control Tower sets us up with a set of preexisting SSO groups & permission sets. This is all documented here: https://docs.aws.amazon.com/controltower/latest/userguide/sso.html

We define additional groups & users, defined as follows:

- _production_ - A production group is defined with admin level permissions inside our production accounts. 
- _iac-bot_ - A special shared SSO user inside the production group. This user is shared and is used specifically to authenticate our IAC tool (terraform) and our scripts with the various production environment accounts.
- _aws root admin_ -  A special shared SSO user who has access to everything. This is essentially the root user for SSO. Should never be logged in or accessed. 

_WIP_

## Workflow

Our playbooks will define these processes in more depth. 

Generally speaking, developers will log into there SSO accounts & access the AWS accounts they need to, to do day to day work. Ie, to see Cloud Trail logs. 

To run an IAC tool, users will log into the _iac_ user & copy/paste the tokens/keys to set environment variables in there terminal. Then run the IAC tool, ie, Terraform, will pick up the environment variables and use it to authenticate with the appropriate environment account & manage infrastructure. 

In the future, the process of setting the keys & tokens as environment variables will be done entirely through the command line.

