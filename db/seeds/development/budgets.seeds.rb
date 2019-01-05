after 'development:join_groups' do 
	puts 'creating a budget for each group...'
	Enterprise.all.each do |enterprise|
		if enterprise.name == "Diverst Inc"
			enterprise.groups.each do |group|
				requester = group.user_groups.first.user if group.user_groups.any?
				FactoryGirl.create(:budget, requester_id: requester.id, group_id: group.id) if requester
			end
		end
	end
	puts 'creating a budget for each group[DONE]'
end