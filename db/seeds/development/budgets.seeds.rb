after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner Populating groups with budgets...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      if enterprise.name == "Diverst Inc"
        enterprise.groups.each do |group|
          annual_budget_id = AnnualBudget.find_by(group_id: group.id, closed: false)&.id
          requester = group.user_groups.where(accepted_member: true).first.user if group.user_groups.any?

          if requester
            budget = Budget.create(requester_id: requester.id,
                                   group_id: group.id,
                                   is_approved: true,
                                   description: "Budget for #{group.name}'s events",
                                   annual_budget_id: annual_budget_id)

            (0..rand(1..3)).each do |i|
              amount = rand(1000..5000)
              BudgetItem.create(budget_id: budget.id,
                                title: "Event for #{group.name}",
                                is_private: false,
                                estimated_amount: amount,
                                available_amount: amount)
            end
          end
        end
      end
    end
    spinner.success("[DONE]")
  end
end
