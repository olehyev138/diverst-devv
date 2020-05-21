class User::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise
  after_action :visit_page, only: [:home, :rewards, :privacy_statement]

  layout 'user'

  def home
    @upcoming_events = current_user.initiatives.upcoming.includes(:owner_group).limit(4) + current_user.invited_initiatives.upcoming.includes(:owner_group).limit(3)
    @posts = posts
    @messages = current_user.messages.includes(:group, :owner).limit(3)
    @enterprise_sponsors = @enterprise.sponsors
  end

  def rewards
    @reward_actions = @enterprise.reward_actions.order(points: :asc)
    @rewards = @enterprise.rewards.order(points: :asc)
    @badges = @enterprise.badges.order(points: :asc)
  end

  def privacy_statement
  end

  private

  def set_enterprise
    @enterprise = current_user.enterprise
  end

  def posts
    # get the news_feed_ids
    news_feed_ids = NewsFeed.where(group_id: current_user.groups.ids).ids

    # get the news_feed_links
    NewsFeedLink
        .joins(:news_feed).joins(joins)
        .includes(:group_message, :news_link, :social_link)
        .approved
        .active
        .where('news_feed_links.news_feed_id IN (?) OR shared_news_feed_links.news_feed_id IN (?)', news_feed_ids, news_feed_ids)
        .where(where, current_user.segments.pluck(:id))
        .order(created_at: :desc)
        .distinct
        .limit(5) # just to not fetch everything, we'll filter it later
  end

  def where
    'news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)'
  end

  def joins
    'LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id
     LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id'
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'home'
      'User\'s Home Page'
    when 'rewards'
      'User\'s Rewards Page'
    when 'privacy_statement'
      'Privacy Statement'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
