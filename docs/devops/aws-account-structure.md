## Intro

We make use of AWS Organizations for proper isolation, authentication/authorization and auditing. Because Diverst is single tenant, full isolation between environments is of most importance. Other benefits of using Organizations includes things like, cost breakdowns per account, auditing with CloudTrail so we can the exact AWS changes that were made in the various environments and security, ie limiting of blast radius. Mistakes, bugs, breaches in one account will likely be limited to that sole account.

## Sources

Our account structure is based off of various AWS whitepapers & documented best practices. Namely though [this guide](https://gruntwork.io/guides/foundations/how-to-configure-production-grade-aws-account-structure) from gruntwork is what we are following, with a few changes. The section 'Deployment Walkthrough' can be skipped.

## Overview

[This diagram](https://gruntwork.io/assets/img/guides/aws-account/aws-account-structure.png) from the guide linked above is essentially what our setup looks like. 

As of now, we have this up manually, without Terraform. The exception is the client account, role & so forth are setup via a bash script when the client is initialized. 

Instead of `Security`, our account is called `Ops`. It is stored in a OU called `Users`. Under the root account we have two nested OU's, called `Envs` and then inside; `Production`. All our environment accounts will be stored under `Envs`, and all our client production accounts will be stored under `Production`. 

Inside of `Ops` we will have a IAM group `production` for client accounts. It will be granted permissions to assume the client account roles. 

Finally we will have an IAM group `admin` under the root account, to manage billing, the organization and so forth.

Each client will have/create:
- A production account which will host all of there infrastructure.
- An IAM role uniquely named inside the production account, allowing use from the `Ops` account.
- A policy granted to the IAM group `production` allowing it to assume the new IAM role.

## Workflow

To make use of the client production account generally speaking, one must
1) Sign into the `Ops` account using there IAM account inside the `production` group.
2) Lastly, `assume` the client production role.

In day to day devops work, all access of production client accounts, should be done through Terraform. Each Terraform environment module assumes the specified role for that environment account. This prevents Terraform from being able to make any changes outside this environment, thus limiting the blast radius of mistakes. 

The secondary option (that should not be used but will be noted here) is if one has an IAM user in the root account. In this case:
1) Sign in to the root account with an IAM user. This IAM user must be part of a group that has a policy that allows use of the `OrganizationAccountAccessRole`
2) Then `assume` the `OrganizationAccountAccessRole` role that AWS Organizations creates by default on account creation.

