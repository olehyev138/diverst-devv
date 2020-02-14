after 'development:enterprise' do
  spinner = TTY::Spinner.new(":spinner Creating API key...", format: :spin_2)
  spinner.run do |spinner|
    api_key = ApiKey.new(
        application_name: 'diverst',
        enterprise: Enterprise.first
    )
    api_key.save!

    spinner.success("[DONE]")
  end
end
