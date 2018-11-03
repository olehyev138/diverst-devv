class GroupMessagePolicy < GroupBasePolicy
  def base_index_permission
    "group_messages_index"
  end

  def base_create_permission
    "group_messages_create"
  end

  def base_manage_permission
    "group_messages_manage"
  end

  def index?
    case group.latest_news_visibility
    when 'public'
      return true if user.policy_group.manage_posts?
      # Everyone can see latest news
      user.policy_group.group_posts_index?
    else
      super
    end
  end

  def base_index_permission
    "group_messages_index"
  end

  def base_create_permission
    "group_messages_create"
  end

  def base_manage_permission
    "group_messages_manage"
  end

  def index?
    case group.latest_news_visibility
    when 'public'
      # Everyone can see latest news
      user.policy_group.group_posts_index?
    else
      super
    end
  end
end
