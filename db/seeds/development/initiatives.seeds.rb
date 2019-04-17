after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner Populating groups with events...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
        outcome = Outcome.create(group_id: group.id)
        pillar = Pillar.create(outcome_id: outcome.id)
        Initiative.create(pillar_id: pillar.id,
                          owner_group_id: group.id,
                          owner_id: enterprise.user_roles.find_by_role_name("Admin").id)
      end
    end
    spinner.success("[DONE]")
  end
end