server '52.86.202.106', user: 'newdeploy', roles: %w(web app db)

set :branch, 'development'
set :rails_env, :production

set :rollbar_env, 'mitre'
#set :rvm_ruby_version, '2.3.0'