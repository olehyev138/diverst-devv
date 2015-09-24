web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -C config/sidekiq.yml -e production
scheduler: bundle exec clockwork clock.rb