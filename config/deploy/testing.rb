server '52.205.194.24', user: 'newdeploy', roles: %w(web app db)

set :branch, 'develop'
set :rails_env, :production

set :rollbar_env, "testing"
