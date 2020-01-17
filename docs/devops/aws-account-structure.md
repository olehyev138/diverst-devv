## Intro

We make use of AWS Organizations for proper isolation, authentication/authorization and auditing. Because Diverst is single tenant, full isolation between environments is of most importance. Other benefits of using Organizations includes things like, cost breakdowns per account, auditing with CloudTrail so we can the exact AWS changes that were made in the various environments and security, ie limiting of blast radius. Mistakes, bugs, breaches in one account will likely be limited to that sole account.

## Sources

Our account structure is based off of various AWS whitepapers & documented best practices. Namely though [this guide](https://gruntwork.io/guides/foundations/how-to-configure-production-grade-aws-account-structure) from gruntwork is what we are following, with a few changes. The section 'Deployment Walkthrough' can be skipped.

## Overview

[This diagram](https://gruntwork.io/assets/img/guides/aws-account/aws-account-structure.png) from the guide linked above is essentially what our setup looks like. 

As of now, we have this up manually, without Terraform. The exception is the client account, role & so forth are setup via a bash script when the client is initialized. 

Instead of `Security`, our account is called `Ops`. It is stored in a OU called `Users`. Under the root account we have two nested OU's, called `Envs` and then inside; `Production`. All our environment accounts will be stored under `Envs`, and all our client production accounts will be stored under `Production`. 

Each client will have:
- A production account which will host all of there infrastructure.
- An IAM role inside the production account, allowing use from the `Ops` account.
- An IAM group & user inside of `Ops` which has permission to assume the role inside the clients account.

## Workflow

To make use of the client production account, one must
1) Sign into the `Ops` account using the appropriate IAM user
2) Then `assume` the client production role.

The secondary option (that should ideally not be used) is if one has an IAM user in the root account. In this case:
1) Sign in to the root account with an IAM user. This IAM user must be part of a group that has a policy that allows use of the `OrganizationAccountAccessRolle`
2) Then `assume` the `OrganizationAccountAccessRole` role that AWS Organizations creates by default on account creation.
