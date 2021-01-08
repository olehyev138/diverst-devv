module ModelHelpers
  def initiative_of_group(group)
    budget = Budget.joins(:annual_budget).find_by(group_id: group.id, annual_budgets: { closed: false })
    budget_item = budget&.budget_items&.first

    outcome = create(:outcome, group: group)
    pillar = create(:pillar, outcome: outcome)
    budget_users = budget_item.present? ? build_list(:budget_user, 1, budget_item: budget_item) : []
    create(:initiative, owner_group_id: group.id, pillar: pillar, budget_users: budget_users)
  end
end
