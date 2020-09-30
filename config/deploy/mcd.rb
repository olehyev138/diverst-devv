server '54.165.196.212', user: 'newdeploy', roles: %w(web app db)

set :branch, 'staging'
set :rails_env, :production

set :rollbar_env, 'mcd'