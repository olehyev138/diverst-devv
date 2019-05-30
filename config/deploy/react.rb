server '18.204.176.20', user: 'newdeploy', roles: %w(web app db)

set :branch, 'react_update'
set :rails_env, :development

set :rollbar_env, 'react'

# npm
set :npm_target_path, -> { release_path.join('client') } # default not set
set :npm_flags, '' # default
set :npm_roles, :all                                     # default
set :npm_env_variables, {}                               # default

# nvm
set :nvm_node, 'v10.13.0'
set :nvm_type, :user

set :ci, 'install' # default
set :bundle_without, %w{test}.join(' ') # this is default
