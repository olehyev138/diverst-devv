class User::DashboardController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def home
    @enterprise = current_user.enterprise
    @upcoming_events = current_user.initiatives.upcoming.includes(:owner_group).limit(4) + current_user.invited_initiatives.upcoming.includes(:owner_group).limit(3)
    @posts = posts
    @messages = current_user.messages.includes(:group, :owner).limit(3)
  end

  def rewards
    @enterprise = current_user.enterprise
    @reward_actions = @enterprise.reward_actions.order(points: :asc)
    @rewards = @enterprise.rewards.order(points: :asc)
    @badges = @enterprise.badges.order(points: :asc)
  end
  
  private
  
  def posts
    if current_user.policy_group.groups_manage?
      NewsFeedLink.joins(:news_feed)
                  .includes(:link)
                  .order(created_at: :desc)
                  .limit(5)
    else
      NewsFeedLink.joins(:news_feed)
                  .joins(joins)
                  .includes(:link)
                  .where(:news_feeds => {:group_id => current_user.active_groups.pluck(:id)}, :approved => true)
                  .where(where, current_user.segments.pluck(:id))
                  .order(created_at: :desc)
                  .limit(5)
    end
  end
  
  def where
    "news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)"
  end
  
  def joins
    "LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id"
  end
end
