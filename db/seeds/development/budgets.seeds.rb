after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner NOT Populating groups with budgets", format: :spin_2)
  spinner.run do |spinner|
    spinner.success("[DONE]")
  end
end
