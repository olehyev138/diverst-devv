
## SSH Access

Describes SSH process for Diverst AWS Environments

#### Overview

- SSH'ing into the AWS environments is something that should rarely if ever be done. The main exception being testing, sandbox environments. SSH'ing into production instances should only ever be done in emergencies.

- Our EC2 instance(s) are managed by an auto-scaling group & Elastic Beanstalk, thus they are not under our control and are _ephemeral_. Nothing should ever be stored on these instances as they are frequently replaced. The main use for SSH'ing into the environment is to make database changes through the Rails console.

- The application EC2 instance(s) reside in a private network. We use a _bastion_ EC2 instance inside a public network to act as a proxy. 

- The _public_ IP for the bastion host and the _private_ IP for one of the EC2 app instances will be needed. Additionally the SSH keys for the relevant environment will be needed as well. 

- We store these IP's in the environment file in our password manager, however the private IP for the app instance changes frequently because of the auto-scaling group, so it is likely it will be necessary to manually access the browser AWS console to retrieve the IP.

- The availability zones of the bastion & ec2 instance should not need to match, as our security groups & routing are set to allow either.

- The SSH keys (public/private) are stored as attachments in our password manager.

#### SSH commands

- Run the ssh-agent in the current terminal

```
eval $(ssh-agent -s)
```

- Add the private key to the keychain.

```
ssh-add <private-key-file>`
```

- SSH with key forwarding (-A) & jump hosts (-J).
```
ssh -A -J ec2-user@<bastion-public-ip> ec2-user@<app-private-ip>`
```
