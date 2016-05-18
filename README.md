# Setting up your development environment

The first thing we need to do is provision a VM using Vagrant. You'll need [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/downloads.html) installed on your machine for this. You'll also need two vagrant plugins:

```bash
vagrant plugin install vagrant-librarian-chef
vagrant plugin install vagrant-rsync-back
```

At this point, you should be able to provision the machine (this will take a while, as in ~20 minutes):

```bash
vagrant up
```

You should now have a fully-provisionned Ubuntu box ready to run Diverst. The next step is to make sure files from your host machine get continuously synced to the guest machine. For this, open a new terminal tab and run the following command:

```bash
vagrant rsync-auto
```

Leave this running while you develop. You can now SSH into the machine by running:

```bash
vagrant ssh
```

Once you're logged into the VM, You'll need to run a few things to setup the app and the DB:

```bash
bundle # Install all dependencies
rake db:create db:migrate db:seed # Create, migrate and seed the development DB
RAILS_ENV=test bundle exec rails db:create # Create the test DB
sudo redis-server /etc/redis/6379.conf # Launch a redis server
bundle exec sidekiq -C config/sidekiq -d -L ~/log/sidekiq.log # Run a sidekiq worker daemon
nohup bundle exec guard >/dev/null 2>&1 & # Run guard for livereload
rails s # Launch the Rails server (Puma)
```