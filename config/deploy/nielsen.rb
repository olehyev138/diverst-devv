server '50.19.14.191', user: 'newdeploy', roles: %w(web app db)

set :branch, 'development'
set :rails_env, :production

set :rollbar_env, 'nielsen'
