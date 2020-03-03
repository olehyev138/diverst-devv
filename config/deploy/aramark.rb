server '34.238.98.183', user: 'newdeploy', roles: %w(web app db)

set :branch, 'staging'
set :rails_env, :production

set :rollbar_env, 'aramark'
