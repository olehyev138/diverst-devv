class User::DashboardController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def home
    @enterprise = current_user.enterprise
    @upcoming_events = current_user.events.upcoming.limit(4) + current_user.invited_events.upcoming.limit(3)
    @news_links = current_user.news_links.limit(3)
    @messages = current_user.messages.limit(3)
  end
end
