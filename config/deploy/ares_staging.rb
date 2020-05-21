server '3.216.121.195', user: 'newdeploy', roles: %w(web app db)

set :branch, 'master'
set :rails_env, :production

set :rollbar_env, 'ares-staging'
