## Diverst Migration

Describe steps for migrating from a legacy environment to beta

Migrating an environment from legacy to beta involves migrating two main aspects of the Diverst infrastructure: 

 - Diverst Database - RDS
 - Diverst file storage - S3 bucket

#### Database

Migrating a legacy database involves:

 - Moving the database to the new AWS account
 - Import database into IAC control (Terraform)
 - Migrating the database schema to Diverst beta

1) Moving database

- Inside the RDS console in the legacy account, select the legacy database & create a snapshot: `beta-migration-<db-name>-snapshot`

- Share the snapshot, adding the account id of the new AWS _environment account_, created it in the environment initialization playbook

- Inside the RDS console of the new AWS environment account, navigate to shared snapshots & restore the database. Ensure to set the database identifier in accordance with Terraform configuration: `<env-name>-db`. Specifically, `<env-name>` must match the value in <env>.tfvars under the same name. If the database is set differently, Terraform will _replace_ the database instead of updating it.

2) Import database into IAC control

We need this new database to be completely managed by Terraform & comply to Terraform configuration. We do need to keep the data of course, so the critical step here is to ensure that Terraform can update the database and not replace it.

- Once the database is available, in your Terraform folder, run the following to import the database into Terraform control. 

`terraform import -var-file=<env>.tfvars module.prod.module.db.aws_db_instance.db <db-identifier>`

- Return to steps in environment playbook. However when running `terraform apply <env>.tfvars` - inspect generated plan closely & ensure that the database is being updated and _not_ replaced.

3) Migrate the database schema

Upon deployment, migration should be done automatically and no manual action should be required.

TODO: user auth migration

#### File Storage Migration

As part of the migration we have migrated from the Paperclip gem to ActiveStorage. On top of the migration because we are migrating our infrastructure we need to migrate an environments files to a new S3 bucket in a new account.

