group_ids = Group.ids
user_ids = User.ids

user_ids.each do |user_id|
  groups_to_join = group_ids.sample([1, 1, 1, 1, 2, 2, 3].sample)

  groups_to_join.each do |g_id|
    UserGroup.create(user_id: user_id, group_id: g_id)
  end
end
