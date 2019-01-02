after 'development:groups' do 
	Enterprise.all.each do |enterprise|
		enterprise.groups.each do |group|
			outcome = FactoryGirl.create(:outcome, group_id: group.id)
			pillar = FactoryGirl.create(:pillar, outcome_id: outcome.id)
			FactoryGirl.create(:initiative, 
								pillar_id: pillar.id, 
								owner_group_id: group.id, 
								owner_id: enterprise.user_roles.find_by_role_name("Admin").id)
		end
	end
end