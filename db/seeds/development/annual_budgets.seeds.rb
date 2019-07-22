after 'development:groups' do  
  spinner = TTY::Spinner.new(":spinner Populating groups with an annual_budget...", format: :spin_2)
  spinner.run do  |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
      	AnnualBudget.create(group_id: group.id,
      						enterprise_id: enterprise.id)
      end
    end
    spinner.success("[DONE]")
  end
end