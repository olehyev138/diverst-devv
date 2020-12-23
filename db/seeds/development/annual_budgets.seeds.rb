after 'development:groups' do  
  spinner = TTY::Spinner.new(":spinner Populating groups with an annual_budget...", format: :spin_2)
  spinner.run do  |spinner|
    spinner.success("[DONE]")
  end
end