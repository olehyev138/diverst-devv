server '23.23.87.126', user: 'newdeploy', roles: %w(web app db)

set :branch, 'staging'
set :rails_env, :production

set :rollbar_env, 'dell'
set :rvm_ruby_version, '2.4.10'