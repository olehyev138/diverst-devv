# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
ENV['TEST_CLUSTER_NODES'] = '1'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'sidekiq/testing'

require 'public_activity/testing'
PublicActivity.enabled = false
WebMock.allow_net_connect!

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

def base
  @base ||= {}
end

# rubocop:disable Style/TrivialAccessors
# attr_writer does not exists in main:Object
def base=(arg)
  @base = arg
end
# rubocop:enable Style/TrivialAccessors

def check_for_leftovers
  tables = ActiveRecord::Base.connection.select_values('show tables')
  leftovers = {}
  tables.each do |table|
    next if %w(schema_migrations vanity_experiments).include? table

    count = ActiveRecord::Base.connection.select_value("select count(*) from #{table}")
    leftovers[table] = count if count > 0
  end

  if leftovers != base
    raise "LEFTOVERS in\n#{leftovers.map { |k, v| "#{k}: #{v}" }.join("\n")}"
  end
end

def set_leftovers
  tables = ActiveRecord::Base.connection.select_values('show tables')
  leftovers = {}
  tables.each do |table|
    next if %w(schema_migrations vanity_experiments).include? table

    count = ActiveRecord::Base.connection.select_value("select count(*) from #{table}")
    leftovers[table] = count if count > 0
  end

  self.base = leftovers
end

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include ReferrerHelpers, type: :controller
  config.include CsvHelpers
  config.include ModelHelpers

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")


  config.before(:suite) do |x|
    set_leftovers
  end

  # Faker - clear random generator before each test, otherwise it will
  # reach its max and throw an error
  config.before(:each) do
    Faker::UniqueGenerator.clear
  end

  config.after(:all) do |x|
    check_for_leftovers
  rescue
    print "\n#{x.class}\n"
    DatabaseCleaner.clean_with :truncation
    raise
  end

  Shoulda::Matchers.configure do |confi|
    confi.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
