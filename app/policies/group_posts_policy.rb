class GroupPostsPolicy < GroupBasePolicy
  def base_index_permission
    'group_posts_index'
  end

  def base_create_permission
    'manage_posts'
  end

  def base_manage_permission
    'manage_posts'
  end

  def view_latest_news?
    # Ability to view latest news depends on settings level
    case group.latest_news_visibility
    when 'public'
      return true if user.policy_group.manage_posts?
      return true if basic_group_leader_permission?('manage_posts')
      return true if basic_group_leader_permission?('group_posts_index')

      # Everyone can see latest news
      user.policy_group.group_posts_index?
    when 'group'
      index?
    when 'leaders_only'
      return true if is_a_manager?('manage_posts')

      is_a_manager?('group_posts_index')
    else
      false
    end
  end
end
