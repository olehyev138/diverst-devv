web: vendor/bundle/bin/puma -C config/puma.rb
worker: vendor/bundle/bin/sidekiq -C config/sidekiq.yml -e production
scheduler: vendor/bundle/bin/clockwork clock.rb