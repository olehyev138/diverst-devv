class GroupNewsLinkPolicy < GroupBasePolicy

  def base_index_permission
    "news_links_index"
  end

  def base_create_permission
    "news_links_create"
  end

  def base_manage_permission
    "news_links_manage"
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
    "news_links_index"
  end

  def base_create_permission
    "news_links_create"
  end

  def base_manage_permission
    "news_links_manage"
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
