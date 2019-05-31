lock '3.9.1'

set :application, 'diverst'
set :repo_url, 'git@github.com:TeamDiverst/diverst-development.git'
set :deploy_to, '/home/newdeploy/diverst'
set :pty, false
set :linked_files, %w(config/application.yml config/database.yml config/puma.rb config/sidekiq.yml config/secrets.yml.key config/secrets.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets)
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, '2.6.0'

set :puma_role, :web
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, -> { "#{shared_path}/tmp/pids/puma.state" }
set :puma_pid, -> { "#{shared_path}/tmp/pids/puma.pid" }
set :puma_bind, 'tcp://0.0.0.0:3000'
set :puma_conf, -> { "#{shared_path}/config/puma.rb" }
set :puma_access_log, -> { "#{shared_path}/log/puma_error.log" }
set :puma_error_log, -> { "#{shared_path}/log/puma_access.log" }
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, true
set :puma_workers, 2

set :sidekiq_config, 'config/sidekiq.yml'
set :sidekiq_log, '/dev/null'
set :sidekiq_processes, 1

set :clockwork_file, 'clock.rb'
set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
set :rollbar_env, ENV['ROLLBAR_ENV']
set :rollbar_role, Proc.new { :app }

namespace :deploy do
  before :finishing, 'deploy:client'

  task :client do
    on primary(:app) do
      within release_path do
        execute "cd '#{release_path}/client' && npm run deploy"
      end
    end
  end
end
