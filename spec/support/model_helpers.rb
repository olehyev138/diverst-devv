module ModelHelpers
  def initiative_of_group(group)
    outcome = create(:outcome, group: group)
    pillar = create(:pillar, outcome: outcome)
    create(:initiative, owner_group_id: group.id, pillar: pillar)
  end
end
