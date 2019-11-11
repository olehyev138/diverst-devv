<img src="https://s3.amazonaws.com/diverst-public/images/diverst.png" height="100" width="100" />

[Diverst](https://diverst.com/) is a software company offering a diversity & inclusion (D&I) platform that helps organizations increase traction for and obtain ROI from their diversity initiatives.


## Setting up your development environment

#### Prerequisites
- [Git](https://git-scm.com/) 
- [Ruby](https://www.ruby-lang.org/en/) (using [RVM](https://rvm.io/))
- [Rails](http://rubyonrails.org/)
- [NodeJS and NPM](https://nodejs.org/en/)
- [MySQL](https://www.mysql.com/)
---

### Installing Prerequisites

*Note: This guide is written for Linux systems*

**Ruby (using RVM)**

Ideally use RVM to install Ruby and do not use the system ruby version so as to make switching versions as easy as possible.

1. Install RVM - refer to the [official guide](https://bundler.io/guides/bundler_2_upgrade.html) and instructions for your specific distro
3. Install Ruby 2.6.0 and set it to default:  
```
rvm install 2.6.0
rvm use 2.6.0 --default
```
4. Verify it: 
`ruby -v`
5. Install bundler:  
`gem install bundler`

**NodeJS & NPM**
1. Install the latest NodeJS and NPM through your distro's package manager

**MySQL**
1. Install the latest version of MySQL for your distro.

2. If necessary, start and enable (start on boot) the MySQL server
```
sudo systemctl start mysql
sudo systemctl enable mysql
```

### Set up

1. Clone your forked repository:  
`git clone https://github.com/<your-username>/diverst-development.git`  
2. All development is based off of `development` branch:  
`git checkout development`  
3. Install all of the gems used by the project:  
`bundle install`
4. Create and initialize the database with seed data and run:  
`rake db:setup`
Note: *You may have to change the username and password in `config/database.yml` to your local MySQL information.
5. Run DB Migration:  
`bin/rails db:migrate RAILS_ENV=development`

6. Change directory into `client/` and install JS packages:
`npm install`

7. Generate & setup an API Key
 - In your rails console (`rails c`) run: 
 ```
 ApiKey.new(application_name: 'diverst', enterprise_id: 1).save!
 ```
 - Create/fill in `client/internals/webpack/.env/` with the generated API key, like so:
 ```
  API_URL=http://localhost:3000
  API_KEY=<KEY>
  ENVIRONMENT=development
  ```

8. In two different shells, start the frontend & backend servers:
`npm start` & `rails s`

9. In your browser, navigate to: `localhost:8082`

### Testing
##### Backend
In order to run all of the RSpec tests, run the command: `bundle exec rspec`  
For more information on RSpec testing, [click here](https://github.com/rspec/rspec-rails).

##### Frontend
To run the frontend (Jest) tests, change directory into `client/` and run: `npm test`

