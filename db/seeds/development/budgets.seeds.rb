after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner Populating each group with budgets...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      if enterprise.name == "Diverst Inc"
        enterprise.groups.each do |group|
          requester = group.user_groups.where(accepted_member: true).first.user if group.user_groups.any?

          if requester
            budget = Budget.create(requester_id: requester.id,
                                   group_id: group.id,
                                   is_approved: true,
                                   description: "Budget for #{group.name}'s events")
            BudgetItem.create(budget_id: budget.id,
                              title: "First event for #{group.name}",
                              is_private: false,
                              estimated_amount: 4500,
                              available_amount: 4500)
          end
        end
      end
    end
    spinner.success("[DONE]")
  end
end
