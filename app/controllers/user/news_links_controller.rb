class User::NewsLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page
  after_action :visit_page, only: [:index]

  layout 'user'

  def index
    authorize NewsLink
    @count = posts.size
    @posts = posts.limit(@limit)
  end

  private

  def posts
    # get the news_feed_ids
    news_feed_ids = NewsFeed.where(group_id: current_user.groups.ids).ids

    # get the news_feed_links
    NewsFeedLink
      .joins(:news_feed).joins(joins)
      .includes(:group_message, :news_link, :social_link)
      .where('news_feed_links.news_feed_id IN (?) OR shared_news_feed_links.news_feed_id IN (?)', news_feed_ids, news_feed_ids)
      .where(approved: true, archived_at: nil)
      .where(where, current_user.segments.pluck(:id))
      .order(created_at: :desc)
      .distinct
  end

  def where
    'news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)'
  end

  def joins
    'LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id
     LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id'
  end

  def set_page
    @limit = 5
    @page = params[:page].present? ? params[:page].to_i : 1
    @limit *= @page
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'User\'s News Feed'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
