class User::NewsLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page

  layout 'user'

  def index
    @count = posts.count
    @posts = posts.limit(@limit)
  end

  private

  def posts
    NewsFeedLink.joins(:news_feed)
          .joins(joins)
          .includes(:news_link, :group_message, :social_link)
          .where(:news_feeds => {:group_id => current_user.groups.pluck(:id)}, :approved => true)
          .where(where, current_user.segments.pluck(:id))
          .order(created_at: :desc)
  end

  def where
    "news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)"
  end

  def joins
    "LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id"
  end

  def set_page
    @limit = 5
    @page = params[:page].present? ? params[:page].to_i : 1
    @limit *= @page
  end
end
