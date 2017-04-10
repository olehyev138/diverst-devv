class User::DashboardController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def home
    @enterprise = current_user.enterprise
    @upcoming_events = current_user.initiatives.upcoming.includes(:owner_group).limit(4) + current_user.invited_initiatives.upcoming.includes(:owner_group).limit(3)
    @news_links = current_user.news_links.limit(3).order(created_at: :desc)
    @messages = current_user.messages.includes(:group, :owner).limit(3)
  end

  def rewards
    @enterprise = current_user.enterprise
  end
end
