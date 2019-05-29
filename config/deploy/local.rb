server 'localhost', user: 'ubuntu', roles: %w(web app db)

set :branch, 'react'
set :rails_env, :development

set :rollbar_env, 'react'
set :deploy_to, '/home/ubuntu/workspace/diverst'
set :rvm_type, :user
set :rvm_custom_path, '/usr/local/rvm'
set :linked_files, %w(config/application.yml config/database.yml config/puma.rb config/sidekiq.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets)
set :bundle_without, [:test]
