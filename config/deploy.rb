lock '3.4.0'

set :application, 'diverst'
set :repo_url, 'git@github.com:vol7/diverst.git'
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || :master
set :deploy_to, '/home/deploy/diverst'
set :pty, false
set :linked_files, %w(config/application.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, '2.3.0'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock" # accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, 1
set :puma_workers, 1
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, true

set :sidekiq_config, 'config/sidekiq.yml'
set :sidekiq_log, '/dev/null'
set :sidekiq_processes, 1

namespace :deploy do

  desc 'Recompile all enterprise themes'
  task :recompile_themes, [:command] => 'deploy:set_rails_env' do |task, args|
    on primary(:app) do
      within current_path do
        with :rails_env => fetch(:rails_env) do
          rake 'themes:recompile'
        end
      end
    end
  end

  after :finishing, "deploy:recompile_themes"

end

require 'appsignal/capistrano'
