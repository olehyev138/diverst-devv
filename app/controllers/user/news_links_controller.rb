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
    # get the news_feed_ids
    news_feed_ids = NewsFeed.where(:group_id => current_user.groups.ids).ids
    
    # get the news_feed_links
    NewsFeedLink
      .joins(:news_feed).joins(joins)
      .includes(:link)
      .where("news_feed_links.news_feed_id IN (?) OR shared_news_feed_links.news_feed_id IN (?)", news_feed_ids, news_feed_ids)
      .where(:approved => true)
      .where(where, current_user.segments.pluck(:id))
      .order(created_at: :desc)
      .distinct
  end

  def where
    "news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)"
  end
  
  def joins
    "LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id"
  end

  def set_page
    @limit = 5
    @page = params[:page].present? ? params[:page].to_i : 1
    @limit *= @page
  end
end
