server '34.205.211.240', user: 'newdeploy', roles: %w(web app db)

set :branch, 'staging'
set :rails_env, :production

set :rollbar_env, 'dell-staging'
