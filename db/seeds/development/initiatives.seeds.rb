after 'development:groups' do 
	puts 'populating app with events...'
	Enterprise.all.each do |enterprise|
		enterprise.groups.each do |group|
			outcome = Outcome.create(group_id: group.id)
			pillar = Pillar.create(outcome_id: outcome.id)
			Initiative.create(pillar_id: pillar.id, 
							  owner_group_id: group.id, 
							  owner_id: enterprise.user_roles.find_by_role_name("Admin").id)
		end
	end
	puts 'populating app with events[DONE]'
end