class GroupNewsLinkPolicy < GroupBasePolicy
  def base_index_permission
    'news_links_index'
  end

  def base_create_permission
    'news_links_create'
  end

  def base_manage_permission
    'news_links_manage'
  end

  def index?
    case group.latest_news_visibility
    when 'public'
      return true if user.policy_group.manage_posts?
      return true if basic_group_leader_permission?('manage_posts')
      return true if basic_group_leader_permission?('news_links_index')

      # Everyone can see latest news
      user.policy_group.news_links_index?
    else
      super
    end
  end

  def edit?
    return true if super

    record.author === user
  end

  def update?
    return true if super

    record.author === user
  end

  def destroy?
    return true if super

    record.author === user
  end
end
