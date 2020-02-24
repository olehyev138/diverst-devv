require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Diverst
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Load core extensions
    Dir[File.join(Rails.root, 'lib', 'core_ext', '*.rb')].each { |l| require l }
    Dir[File.join(Rails.root, 'lib', '*.rb')].each { |l| require l }

    config.autoload_paths << Rails.root.join('app/models/csv_export')

    # Yarn assets
    config.assets.paths   << Rails.root.join('node_modules')

    config.assets.paths   << Rails.root.join('tmp', 'themes') # Custom themes

    config.active_job.queue_adapter = :sidekiq

    Rails.application.routes.default_url_options[:host] = ENV['DOMAIN'] || 'localhost:3000'

    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden

    ActionMailer::Base.delivery_method = :smtp
  end
end
