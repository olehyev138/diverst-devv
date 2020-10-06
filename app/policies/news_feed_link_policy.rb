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

  def archived?
    policy_group.manage_all? || policy_group.auto_archive_manage?
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
  alias_method :un_pin?, :group_update?
  alias_method :approve?, :group_update?
  alias_method :archive?, :group_update?
  alias_method :un_archive?, :archived?

  class Scope < Scope
    def joined_with_group
      scope.joins(
          'LEFT OUTER JOIN `shared_news_feed_links` ' +
              'ON `news_feed_links`.`id` = `shared_news_feed_links`.`news_feed_link_id` ' +
              'LEFT OUTER JOIN `news_feeds` ' +
              'ON `news_feeds`.`id` = `news_feed_links`.`news_feed_id` OR `news_feeds`.`id` = `shared_news_feed_links`.`news_feed_id`' +
              'LEFT OUTER JOIN `groups` ' +
              'ON `groups`.`id` = `news_feeds`.`group_id` ' +
              'LEFT OUTER JOIN `enterprises` ' +
              'ON `enterprises`.`id` = `groups`.`enterprise_id` ' +
              'LEFT OUTER JOIN `group_leaders` ' +
              'ON `group_leaders`.`group_id` = `groups`.`id` ' +
              'LEFT OUTER JOIN `user_groups` ' +
              'ON `user_groups`.`group_id` = `groups`.`id`'
        )
    end

    def group_base
      group.news_feed_links.custom_or(group.shared_news_feed_links)
    end

    delegate :archived?, to: :policy

    def resolve
      if index? && action == :index
        super(policy.base_index_permission)
      elsif archived? && action == :archived
        scope.archived.left_joins(:enterprise).where(enterprises: { id: user.enterprise.id })
      end
    end
  end
end
