class Groups::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_client
  before_action :set_twitter_accounts
  before_action :set_page,    only: [:index, :pending]
  before_action :set_link,    only: [:approve, :pin, :unpin]

  layout 'erg'

  def index
    @tweets = five_recent_tweets
    if GroupPolicy.new(current_user, @group).manage?
      without_segments
    elsif GroupPostsPolicy.new(current_user, [@group]).view_latest_news?
      with_segments
    else
      @count = 0
      @posts = []
    end
    filter_posts(@posts)
  end

  def five_recent_tweets
    all_tweets = []
    @accounts.find_each do |account|
      all_tweets += TwitterClient.get_tweets(account.account)
    end

    all_tweets = all_tweets.sort do |a, b|
      case
      when a.created_at < b.created_at
        1
      when a.created_at > b.created_at
        -1
      end
    end

    if all_tweets.size >= 5
      return all_tweets[0 ... 5]
    else
      return all_tweets
    end
  end

  def pending
    if @group.enterprise.enable_social_media?
      @posts = @group.news_feed_links.includes(:news_link, :group_message, :social_link).not_approved.where(archived_at: nil).order(created_at: :desc)
    else
      @posts = @group.news_feed_links.includes(:news_link, :group_message).not_approved.where(archived_at: nil).order(created_at: :desc)
    end
  end

  def approve
    @link.approved = true
    if @link.save
      track_activity(@link, :approve)
    else
      flash[:alert] = 'Link not approved'
    end
    redirect_to :back
  end

  def pin
    @link.is_pinned = true
    if !@link.save
      flash[:alert] = 'Link was not pinned'
    end
    redirect_to :back
  end

  def unpin
    @link.is_pinned = false
    if !@link.save
      flash[:alert] = 'Link was not unpinned'
    end
    redirect_to :back
  end

  protected

  def without_segments
    @posts = NewsFeed.all_links_without_segments(@group.news_feed.id, @group.enterprise)
    @count = @posts.count
    @posts = @posts.order(is_pinned: :desc, created_at: :desc)
                   .limit(@limit)
  end

  def with_segments
    segment_ids = current_user.segment_ids

    return without_segments if segment_ids.empty?

    @posts = NewsFeed.all_links(@group.news_feed.id, segment_ids, @group.enterprise)
    @count = @posts.count
    @posts = @posts.order(is_pinned: :desc, created_at: :desc)
               .limit(@limit)
  end

  def filter_posts(posts)
    @posts = posts.select { |news|
      news.news_link || news.group_message || news.social_link
    }
  end

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_twitter_accounts
    @accounts = @group.twitter_accounts.all
  end

  def set_client
    @client = TwitterClient.client
  end

  def set_page
    @limit = 5
    @page = params[:page].present? ? params[:page].to_i : 1
    @limit *= @page
  end

  def set_link
    @link = @group.news_feed_links.find(params[:link_id])
  end
end
