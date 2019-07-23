after 'development:groups' do
  spinner = TTY::Spinner.new(':spinner Updating annual_budget...', format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.annual_budgets.each do |annual_budget|
        annual_budget.update(amount: annual_budget.group.annual_budget || 0, available_budget:                                                                             annual_budget.group.available_budget,
                             leftover_money: annual_budget.group.leftover_money, expenses: annual_budget.group.spent_budget,
                             approved_budget: annual_budget.group.approved_budget)
      end
    end
    spinner.success("[DONE]")
  end
end
