RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
    # FactoryBot.lint
  ensure
    DatabaseCleaner.clean
  end
end
