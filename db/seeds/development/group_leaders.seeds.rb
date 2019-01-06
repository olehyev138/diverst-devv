after 'development:join_groups' do 
	puts 'populating app with group leaders...'
	Enterprise.all.each do |enterprise|
		enterprise.groups.each do |group|
			GroupLeader.create(group_id: group.id, 
							   user_id: group.user_groups.where(accepted_member: true).first.user.id,
							   user_role_id: enterprise.user_roles.find_by_role_name("Group Leader").id) unless group.user_groups.where(accepted_member: true).empty?
		end
	end
	puts 'populating app with group leaders[DONE]'
end
