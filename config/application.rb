require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_model/railtie'
require 'active_storage/engine'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Diverst
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Load core extensions
    Dir[File.join(Rails.root, 'lib', 'core_ext', '*.rb')].each { |l| require l }
    Dir[File.join(Rails.root, 'lib', '*.rb')].each { |l| require l }

    config.active_job.queue_adapter = :sidekiq

    Rails.application.routes.default_url_options[:host] = ENV['DOMAIN'] || 'localhost:3000'

    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden

    ActionMailer::Base.delivery_method = :smtp

    # Cross Domain Request
    config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
        # resource '/assets/*', headers: :any, methods: [:get]
        resource '/system/*', headers: :any, methods: [:get]
      end
    end

    config.middleware.insert_before ActionDispatch::Static, Rack::Rewrite do
      rewrite %r{^(?!/sidekiq|\/api|\/system|\/rails).*}, '/', not: %r{(.*\..*)}
    end

    # rails api
    config.api_only = true

    # enable garbage collection instrumentation for NewRelic
    GC::Profiler.enable

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    # config.assets.enabled = true

    config.middleware.use ActiveRecord::Migration::CheckPending
    config.middleware.use Rack::Deflater

      # access token
    config.access_tokens = {
      # defines how long an aws url is good for
      token_refresh_interval: 2.hours,
      # 7 day token
      week_long_token_refresh_interval: 7.days,
      # gives longer access to an aws url for emails
      long_token_refresh_interval: 90.days
    }

    # password reset timeframe (in hours)
    config.password_reset_time_frame = ENV['PASSWORD_RESET_TIME_FRAME'] || 6

    # config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 20, wait_timeout: 30, wait_overtime: 60, service_past_wait: false
  end
end
