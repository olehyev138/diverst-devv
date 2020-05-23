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

  def group_visibility_setting
    'latest_news_visibility'
  end

  def view_latest_news?
    index?
  end
end
