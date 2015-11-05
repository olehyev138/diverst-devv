web: bin/puma -C config/puma.rb
worker: bin/sidekiq -C config/sidekiq.yml -e production
scheduler: bin/clockwork clock.rb