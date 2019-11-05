Diverst::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # config.assets.enabled = false

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  # Don't generate assets and helpers when using `rails generate`
  config.generators.assets = false
  config.generators.helper = false

  # Disable on-disk logging to accelerate Vagrant development
  config.logger = ActiveSupport::Logger.new(nil)

  # Enable Bullet to track redundant DB queries
  config.after_initialize do
    # Bullet.enable = true
    # Bullet.rails_logger = true
    # Bullet.add_footer = true
  end

  # make the public directory work
  config.public_file_server.enabled = true

  config.eager_load = false

  # Save ActiveStorage attachments locally
  config.active_storage.service = :local
end
