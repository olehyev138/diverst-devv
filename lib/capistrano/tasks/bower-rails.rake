namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        execute :rake, 'bower:install CI=true'
      end
    end
  end
end
before 'deploy:compile_assets', 'bower:install'