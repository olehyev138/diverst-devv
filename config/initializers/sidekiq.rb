sidekiq_config = { url: ENV['REDIS_URL'] }
Sidekiq.default_worker_options = { 'backtrace' => true }
