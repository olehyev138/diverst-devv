after 'production:enterprise' do
  spinner = TTY::Spinner.new(":spinner Creating Tech Admin User...", format: :spin_2)
  spinner.run do |spinner|
    api_key = ApiKey.new(
        application_name: 'diverst',
        enterprise: Enterprise.first
    )
    api_key.save!

    spinner.success("[DONE]")
  end
end
