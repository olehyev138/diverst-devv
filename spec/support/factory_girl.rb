RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      puts "START"
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      puts "CLEAN"
      DatabaseCleaner.clean
    end
  end
end