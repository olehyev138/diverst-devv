server '34.231.192.48', user: 'newdeploy', roles: %w(web app db)

set :branch, 'development'
set :rails_env, :production

set :rollbar_env, 'amazon'
