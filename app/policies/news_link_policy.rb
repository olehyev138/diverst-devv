class NewsLinkPolicy < GroupBasePolicy
  def base_index_permission
    'news_links_index'
  end

  def base_create_permission
    'news_links_create'
  end

  def base_manage_permission
    'news_links_manage'
  end

  def update?
    record.author === user || super
  end

  def destroy?
    record.author === user || super
  end
end
