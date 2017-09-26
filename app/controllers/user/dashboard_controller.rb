class User::DashboardController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def home
    @enterprise = current_user.enterprise
    @upcoming_events = current_user.initiatives.upcoming.includes(:owner_group).limit(4) + current_user.invited_initiatives.upcoming.includes(:owner_group).limit(3)
    @posts = NewsFeedLink.joins(:news_feed).includes(:link).where(:news_feeds => {:group_id => current_user.groups.pluck(:id)}, :approved => true)
    @messages = current_user.messages.includes(:group, :owner).limit(3)
  end

  def rewards
    @enterprise = current_user.enterprise
    @reward_actions = @enterprise.reward_actions.order(points: :asc)
    @rewards = @enterprise.rewards.order(points: :asc)
    @badges = @enterprise.badges.order(points: :asc)
  end
end
