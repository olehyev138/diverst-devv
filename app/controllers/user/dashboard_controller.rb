class User::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise

  layout 'user'

  def home
    @upcoming_events = current_user.initiatives.upcoming.includes(:owner_group).limit(4) + current_user.invited_initiatives.upcoming.includes(:owner_group).limit(3)
    @posts = posts
    @messages = current_user.messages.includes(:group, :owner).limit(3)
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
    NewsFeedLink.joins(:news_feed)
              .joins(joins)
              .includes(:link)
              .where(:news_feeds => {:group_id => current_user.active_groups.pluck(:id)}, :approved => true)
              .where(where, current_user.segments.pluck(:id))
              .order(created_at: :desc)
              .limit(5) #just to not fetch everything, we'll filter it later
  end
  
  def where
    "news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)"
  end
  
  def joins
    "LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id"
  end
end
