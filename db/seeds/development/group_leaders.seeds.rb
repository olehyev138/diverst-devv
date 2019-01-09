after 'development:join_groups' do 
	spinner = TTY::Spinner.new("[:spinner] Populating groups with group leaders...", format: :classic)
    spinner.run('[DONE]') do |spinner|
		Enterprise.all.each do |enterprise|
			enterprise.groups.each do |group|
				GroupLeader.create(group_id: group.id, 
								   user_id: group.user_groups.where(accepted_member: true).first.user.id,
								   user_role_id: enterprise.user_roles.find_by_role_name("Group Leader").id) unless group.user_groups.where(accepted_member: true).empty?
			end
		end
	end
end
