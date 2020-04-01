class NewsFeedLinkPolicy < GroupBasePolicy
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

  def update?
    (record.author == user if NewsFeedLink === record) || super
  end

  def group_update?
    NewsFeedLinkPolicy.new(user, [group, NewsFeedLink], params).update?
  end

  def is_a_member?
    super || (NewsFeedLink === record && (user.group_ids && record.shared_news_feeds.map { |snf| snf.group_id }).present?)
  end

  alias_method :pin?, :group_update?
  alias_method :archive?, :group_update?

  class Scope < Scope
    def is_member(permission)
      "(groups.latest_news_visibility IN ('public', 'non_member', 'group') AND user_groups.user_id = #{quote_string(user.id)} AND #{policy_group(permission)})"
    end

    def is_not_a_member(permission)
      "(groups.latest_news_visibility IN ('public', 'non_member') AND #{policy_group(permission)})"
    end

    def group_base
      group.news_feed_links.custom_or(group.shared_news_feed_links)
    end

    def resolve
      super(policy.base_index_permission)
    end
  end
end
