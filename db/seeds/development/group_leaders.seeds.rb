after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner Populating groups with group leaders...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
        GroupLeader.create(group_id: group.id,
                           user_id: group.user_groups.where(accepted_member: true).first.user.id,
                           position_name: 'Group Leader',
                           user_role_id: enterprise.user_roles.find_by_role_name("Group Leader").id) unless group.user_groups.where(accepted_member: true).empty?
      end
    end
    spinner.success("[DONE]")
  end
end
