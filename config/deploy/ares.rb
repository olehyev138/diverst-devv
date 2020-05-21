server '3.212.185.88', user: 'newdeploy', roles: %w(web app db)

set :branch, 'development'
set :rails_env, :production

set :rollbar_env, 'ares'
