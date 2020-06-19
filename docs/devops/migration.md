## Diverst Migration

Here we will describe the steps for migrating from a legacy environment to beta

This document is intended to be followed in conjunction with the environment initialization document.

We will outline the steps for initializing & migrating the environment & delegate to the environment initialization document when applicable.

Migrating an environment from legacy to beta involves supplementing & changing a few steps in the normal environment initialization process:

- The environment database will be migrated from the legacy account & imported into Terraform
- The S3 file storage bucket will be synced with the new bucket

#### Preliminary initialization

Follow the environment initialization document up to & stopping before step 'E - Run Terraform'

#### Database Migration

Before running Terraform & creating infrastructure, we need to migrate the database & import it.

Migrating a legacy database involves:

 - Moving the database to the new AWS account
 - Import database into IAC control (Terraform)

##### 1) Moving database to new AWS account

- Inside the RDS console in the legacy account, select the legacy database & create a snapshot: `beta-migration-<db-name>-snapshot`

- Share the snapshot, adding the account id of the new AWS _environment account_, created in the previous step

- Inside the RDS console of the new AWS environment account, navigate to shared snapshots & restore the database. Ensure to set the _DB Instance Identifier_ in accordance with Terraform configuration: `<env-name>-db`. `<env-name>` must match the value in <env>.tfvars under the same name. *If the database is set differently, Terraform will _replace_ the database instead of updating it*. *TODO: describe config options*

##### 2) Import database into IAC control

We need this new database to be completely managed by Terraform & comply to Terraform configuration. We do need to keep the data of course, so the critical step here is to ensure that Terraform updates the database configuration and *does not replace it*.

- Once the database is available, in your Terraform folder, run the following to import the database into Terraform control. 

`terraform import -var-file=<env>.tfvars module.prod.module.db.aws_db_instance.db <db-identifier>`

#### Infrastructure initialization

Return to the environment initialization document & continue to the next step, running the _Run Terraform_ step.

Inspect the generated plan closely & ensure that Terraform is *updating the database & not replacing it*. 

Do not run the database initialization step & continue to _File Storage Migration_

#### File Storage Migration

Because we are migrating to a new AWS account & migrating from paperclip to active storage, we need to move the environments files to a new S3 bucket.

1) Add bucket policy to legacy/source bucket

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DelegateS3Access",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<destination-account-id>:root"
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::<source-bucket>/*",
                "arn:aws:s3:::<source-bucket>"
            ]
        }
    ]
 }
```

2) In the new AWS account, create an IAM user `s3-migration-user`. Create this user with cli access only and no permissions, download the CSV file. Attach an inline policy to this user: 

````
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::<source-bucket>",
                "arn:aws:s3:::<source-bucket>/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::<destination-bucket>",
                "arn:aws:s3:::<destination-bucket>/*"
            ]
        }
    ]
}
````

3) In a new terminal, authenticate with the *new* IAM user (s3-migration-user) by exporting the keys in the CSV file previously exported. Run the following command to sync the legacy S3 bucket with the new S3 bucket

```
aws s3 sync s3://<source-bucket> s3://<destination-bucket>
```
envi
4) Now clean up and delete the bucket policy in the legacy bucket and the s3 migration IAM user in the new account. 

#### Deploy

As directed in the environment initialization document, follow the deployment playbook to completion.

#### Migrate the database

SSH into a ec2 instance in the new environment, change directories into the app directory and run 

```
rails db:migrate
```

_Notes & Known Issues_:
   - Will take a while, ensure network connection is stable
   - Specifically `MakeFieldPolymorphic` & `MakeFieldDataPolymorphic` can take a very long time
   - State of fields in legacy databases is dubious, there uniqueness validations dont work properly and it is possible there will be field data (`info`) referencing field records that do not exist. Thus it is possible `MakeFieldPolymorphic` & `MakeFieldDataPolymorphic` will break because of these things. Manual intervention with the rails console will be needed to fix duplicate fields. When non existent fields are referenced, they are skipped by the migration, effectively deleting it.
   - If there are new tables or foreign keys, `ConvertKeysToBigInt` might break because the id types are mismatched (beta uses bigint). The `ConvertKeysTOBigInt` Migration needs to be updated to remove the foreign keys, change the primary & foreign key types, or the new migration may be updated as well. Changing of foreign key types should be on the new table first, ie `video_rooms` references `initiatives`, so`video_rooms` should be updated before `initiatives`. 
   - `AddPreviousAndNextToUpdates` references a job and sometimes fails on the first run - _TODO: more info_
   - Duplicate column issues from rerunning migrations - if new migrations have been added _from_ legacy, the legacy database will re run the migration and fail with duplicate column issues. Legacy migrations therefore need to be added with checks for column & table existence. 
   - Custom texts strings being nil/empty strings - migration was added to fix this
   - Field data being too long (string length max is 255) - migration added to update type from `string` to `text`
   
#### Api Key & Authentication

_TODO_

#### DNS

Finally, run the DNS step in the environment initialization document to complete the process.
