module ModelHelpers
  def initiative_of_group(group)
    annual_budget_id = AnnualBudget.find_by(closed: false, group_id: group.id)&.id

    outcome = create(:outcome, group: group)
    pillar = create(:pillar, outcome: outcome)
    create(:initiative, owner_group_id: group.id, pillar: pillar, annual_budget_id: annual_budget_id)
  end
end
