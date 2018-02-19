source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '~> 4.2.7.1'
gem 'mysql2', '~> 0.4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails', '~> 4.1', '>= 4.1.1'
gem 'turbolinks', '~> 2.5', '>= 2.5.3'
gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

gem 'nokogiri', '>= 1.7.2' # need to specify this explicitly, old version has exploit

gem 'puma', '~> 3.1' # Better web server than WEBRick
gem 'figaro', '~> 1.1', '>= 1.1.1' # Inject ENV from application.yml
gem 'devise', '~> 3.5', '>= 3.5.6' # Authentication
gem 'devise_invitable', '~> 1.5', '>= 1.5.5' # Invite system (admins invite normal users)
gem 'simple_form', '~> 3.2', '>= 3.2.1' # Better forms
gem 'cocoon', '~> 1.2', '>= 1.2.8' # Nested forms (deals with the JS for you)
gem 'ruby-saml', '>= 1.3.0'
gem 'sidekiq', '< 5' # Background jobs
gem 'devise-async', '~> 0.10.1' # Performs many devise tasks in the background using Sidekiq
gem 'sinatra', '~> 1.4', '>= 1.4.7', require: nil # Required for sidekiq's dashboard
gem 'seedbank', '~> 0.3.0' # Support for multiple seed files and their ordering
gem 'oj', '~> 2.14', '>= 2.14.6' # Faster JSON implementation
gem 'faker', '~> 1.6', '>= 1.6.3' # Fake seed data easily
gem 'active_model_serializers', '~> 0.9.6' # Serializes your models in a string a format
gem 'devise_token_auth', '~> 0.1.37' # JWT tokens for auth
gem 'firebase_token_generator', '~> 2.0' # Generate auth tokens
gem 'firebase', '~> 0.2.6' # Used for realtime messaging in mobile app
gem 'houston', '~> 2.2', '>= 2.2.3' # Apple push notifications
gem 'gcm', '~> 0.1.1' # Android push notifications
gem 'bower-rails', '~> 0.10.0' # Bower integration with Rails
gem 'clockwork', '~> 1.2' # Schedule recurring jobs
gem 'pismo', '~> 0.7.4' # Extracts metadata from an URL
gem 'active_link_to', '~> 1.0', '>= 1.0.3' # Automatically add an active class to current nav link
gem 'paperclip', '~> 4.3'# Handle attachments for models and forms
gem 'aws-sdk', '< 2.0'# The official AWS SDK
gem 'kaminari', '~> 0.16.3' # Pagination
gem 'jquery-datatables-rails', '~> 3.3' # Datatables
gem 'ajax-datatables-rails', '~> 0.3.1' # Adds AJAX routes for datatables queries
gem 'elasticsearch-model', '~> 0.1'
gem 'elasticsearch-rails', '~> 0.1'
gem 'sprockets', '>= 3.0.0'
gem 'sprockets-es6', '~> 0.9.0'
gem 'awesome_print', '~> 1.6', '>= 1.6.1' # Better pp
gem 'yam', '~> 2.5' # Yammer ruby SDK
gem 'httparty', '~> 0.13' # HTTP request library
gem 'liquid', '~> 3.0', '>= 3.0.6' # Templating engine used for email templates
gem 'autoprefixer-rails', '~> 6.3', '>= 6.3.3.1' # Automatically adds vendor prefixes to CSS declarations
gem 'fog', '~> 1.37' # AWS SDK
gem 'validate_url', '~> 1.0', '>= 1.0.2' # Active Model validation for URLs
gem 'omniauth-linkedin-oauth2', '~> 0.1.5' # OAuth for LinkedIn
gem 'omniauth-oauth2', '1.3.1' # Temporary fix to address: https://github.com/decioferreira/omniauth-linkedin-oauth2/issues/28
gem 'activerecord-import', '~> 0.12.0' # Adds a faster way to INSERT multiple rows in the DB
gem 'inline_svg', '~> 0.6.2' # Extract SVG files' content into the HTML
gem 'pundit', '~> 1.1' # Authorization
gem 'draper', '~> 2.1' # Decorators for views
gem 'daemons', '~> 1.2', '>= 1.2.3' # For capistrano-clockwork
gem 'icalendar', '~> 2.3' # For exporting events to your calendar
gem 'simple_form_fancy_uploads', git: "https://github.com/TeamDiverst/simple_form_fancy_uploads.git", branch: "paperclip_version"
gem 'ransack', '~> 1.8', '>= 1.8.2' # For search forms
gem 'ckeditor', '~> 4.2', '>= 4.2.3'

gem 'mailgun_rails', '~> 0.8.0'
gem 'enumerize', '~> 2.0'
gem 'jbuilder', '~> 2.6'

gem 'public_activity', '~> 1.5'

gem 'rollbar', '~> 2.14.1'

gem 'ruby-oembed', '~> 0.12.0'

gem 'julia_builder', '~> 0.2.0'
gem 'date_validator', '~> 0.9.0'
gem "thor", "0.19.1"# Expected string default value for '--decorator'; got true (boolean) - setting version removes this message
gem 'sanitize_email', '~> 1.2.2'
gem 'rack-cors', "~> 1.0.2", :require => "rack/cors"

group :development, :test do
  gem 'spring', '~> 1.6.2' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'rb-readline'
  gem 'rack-livereload'
  # The 3 gems above are for livereloading your code
  gem 'quiet_assets' # Silences asset logs
  gem 'active_record_query_trace' # View which line is making each SQL query in the logs
  gem 'rspec-rails', '~> 3.0' # Testing framework
  gem 'factory_girl_rails' # Create mock objects for testing
  gem 'capybara' # Helpers for feature specs
  gem 'poltergeist' # Allows support for JS in feature specs
  gem 'database_cleaner' # Necessary to clean the DB between tests
  gem 'pry-rails' # Better Rails console
  gem 'pry-theme' # Themes for pry
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.1'
  gem 'timecop', '~> 0.8.1'
  gem 'byebug' # Debugger
  gem 'pundit-matchers', '~> 1.3.1'
end

group :test do
  gem 'rspec_junit_formatter', '~> 0.2.3'
  gem 'simplecov', '~> 0.13.0'
  gem 'test_after_commit', '~> 1.1'
  gem 'elasticsearch-extensions', '~> 0.0.26'
  gem 'clockwork-test', '~> 0.2.0'
  gem 'webmock', '~> 3.1.1'
end

group :development do
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
  gem 'capistrano-bower'
  gem 'capistrano-rails-console'
  gem 'capistrano-sidekiq'
  gem 'capistrano-clockwork'
  gem 'spring-commands-rspec'
  gem 'better_errors' # Different error page
  gem 'binding_of_caller'
  gem 'bullet' # Detects N+1 queries
  gem 'parallel_tests'
  gem 'meta_request' # Necessary for rails_panel Chrome extension
  # gem 'flamegraph'
  # gem 'rack-mini-profiler'
  # gem 'stackprof'
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.3', '>= 1.3.1'
  gem 'rufo'
  gem 'bundler-audit'
end

group :staging, :production do
  gem 'syslogger', '~> 1.6.0' # Log to syslog, which is then sent to Loggly
  gem 'lograge', '~> 0.3'
  gem 'newrelic_rpm'
end
