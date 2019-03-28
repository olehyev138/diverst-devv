<img src="https://s3.amazonaws.com/diverst-public/images/diverst.png" height="100" width="100" />

[Diverst](https://diverst.com/) is a software company offering a diversity & inclusion (D&I) platform that helps organizations increase traction for and obtain ROI from their diversity initiatives.


## Setting up your development environment

#### Prerequisites
- [Git](https://git-scm.com/) (Instructions not included)
- [Ruby](https://www.ruby-lang.org/en/) (using [RVM](https://rvm.io/))
- [Rails](http://rubyonrails.org/)
- [NodeJS and NPM](https://nodejs.org/en/)
- [MySQL](https://www.mysql.com/)
- [Yarn](https://yarnpkg.com/en/)

---

### Installing Prerequisites
*Note*: This guide was created on a newly installed VM of Ubuntu Desktop 16.04.3 LTS.  

Update your package lists:  
`sudo apt-get update`  

If necessary, upgrade your packages:  
`sudo apt-get upgrade`

**Ruby (using RVM)**
1. Install RVM:  
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | sudo bash -s stable
```
2. Relogin to your system/terminal.  
3. Install Ruby 2.3.0 and use it by default:  
```
rvm install 2.3.0
rvm use 2.3.0 --default
```
4. Verify it:  
`ruby -v`
5. Install bundler:  
`gem install bundler`

**NodeJS & NPM**
1. Install NodeJS and NPM and symlink the below directory:  
```
sudo apt-get install nodejs npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
```

**MySQL**
1. Install MySQL Client, Server, and a package that let's the mysql2 gem connect to MySQL:  
`sudo apt-get install mysql-server mysql-client libmysqlclient-dev`
2. If necessary, start and enable (start on boot) the MySQL server
```
sudo systemctl start mysql
sudo systemctl enable mysql
```

### Set up

1. Clone your forked repository:  
`git clone https://github.com/<your-username>/diverst-development.git`  
2. It is likely that you'll want to be on the `development` branch:  
`git checkout development`  
3. Install all of the gems used by the project:  
`bundle install`
4. Create and initialize the database with seed data and run:  
`rake db:setup`  
Note: *You may have to change the username and password in `config/database.yml` to your local MySQL information. Also note
that the seed data generated on initialization is defined in db/seeds/development*
5. Run DB Migration:  
`bin/rails db:migrate RAILS_ENV=development`
6. Install Yarn:  
`sudo npm install -g yarn`
7. Get the Yarn packages:  
`yarn`

**That's it! Start the server using: `bin/rails server`**  

### Testing
In order to run all of the RSpec tests, run the command: `bundle exec rspec`  
For more information on RSpec testing, [click here](https://github.com/rspec/rspec-rails).

### Seed Data
To view the rake tasks to run certain seed data, type `rake -T`.
Run `rake db:seed:development` to initialize development database with seed data defined in files found in db/seeds/development.
