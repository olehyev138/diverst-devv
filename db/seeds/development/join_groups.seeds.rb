after 'development:groups' do
  spinner = TTY::Spinner.new("[:spinner] Adding users to groups...", format: :classic)
  spinner.run('[DONE]') do |spinner|
    Enterprise.all.each do |enterprise|
      group_ids = enterprise.groups.ids
      user_ids = enterprise.users.ids

      user_groups = []

      user_ids.each do |user_id|
        groups_to_join = group_ids.sample([1, 1, 1, 1, 2, 2, 3].sample) # Join 1, 2 or 3 groups. More likely to join less

        groups_to_join.each do |g_id|
          user_groups << UserGroup.new(user_id: user_id, group_id: g_id, accepted_member: true)
        end
      end

      UserGroup.import user_groups
    end
  end
end