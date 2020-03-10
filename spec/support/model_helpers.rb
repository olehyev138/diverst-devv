module ModelHelpers
  def initiative_of_group(group)
    annual_budget = AnnualBudget.find_by(closed: false, group_id: group.id)
    budget_item = annual_budget&.budget_items&.first

    outcome = create(:outcome, group: group)
    pillar = create(:pillar, outcome: outcome)
    create(:initiative, owner_group_id: group.id, pillar: pillar, budget_item: budget_item)
  end
end
