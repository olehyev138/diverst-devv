class User::NewsLinksController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def index
    @posts = NewsFeedLink.joins(:news_feed).includes(:link).where(:news_feeds => {:group_id => current_user.groups.pluck(:id)}, :approved => true)
  end
end
