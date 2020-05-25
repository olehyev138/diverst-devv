class NewsLinkPolicy < GroupBasePolicy
  def base_index_permission
    'group_posts_index'
  end

  def base_create_permission
    'news_links_create'
  end

  def base_manage_permission
    'manage_posts'
  end

  def group_visibility_setting
    'latest_news_visibility'
  end

  def update?
    record.author === user || super
  end

  def destroy?
    record.author === user || super
  end
end
