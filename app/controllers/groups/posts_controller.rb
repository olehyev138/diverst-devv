class Groups::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_client
  before_action :set_twitter_accounts
  before_action :set_page,    only: [:index, :pending]
  before_action :set_link,    only: [:approve, :pin, :unpin]
  after_action :visit_page, only: [:index, :pending]

  layout 'erg'

  def index
    @search = params[:search]
    @tweets = recent_tweets
    if GroupPolicy.new(current_user, @group).manage?
      without_segments
    elsif GroupPostsPolicy.new(current_user, [@group]).view_latest_news?
      with_segments
    else
      @count = 0
      @posts = []
    end

    if @group.enterprise.enable_social_media?
      @pending_posts = @group.news_feed_links.includes(:news_link, :group_message, :social_link).where(approved: false, archived_at: nil).order(created_at: :desc)
      filter_posts(@posts.includes(:news_link, :group_message, :social_link).where(approved: true, archived_at: nil))
    else
      @pending_posts = @group.news_feed_links.includes(:news_link, :group_message).where(approved: false, archived_at: nil).order(created_at: :desc)
      filter_posts(@posts.includes(:news_link, :group_message).where(approved: true, archived_at: nil))
    end
  end

  def pending
    if GroupPolicy.new(current_user, @group).manage?
      without_segments
    elsif GroupPostsPolicy.new(current_user, [@group]).view_latest_news?
      with_segments
    else
      @count = 0
      @posts = []
    end


    if @group.enterprise.enable_social_media?
      @pending_posts = @group.news_feed_links.includes(:news_link, :group_message, :social_link).where(approved: false, archived_at: nil).order(created_at: :desc)
      filter_posts(@posts.includes(:news_link, :group_message, :social_link).where(approved: true, archived_at: nil))
    else
      @pending_posts = @group.news_feed_links.includes(:news_link, :group_message).where(approved: false, archived_at: nil).order(created_at: :desc)
      filter_posts(@posts.includes(:news_link, :group_message).where(approved: true, archived_at: nil))
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
    unless @link.save
      flash[:alert] = 'Link was not pinned'
    end
    redirect_to :back
  end

  def unpin
    @link.is_pinned = false
    unless @link.save
      flash[:alert] = 'Link was not unpinned'
    end
    redirect_to :back
  end

  protected

  def split_search_terms
    (@search || '').split(' ')
  end

  def recent_tweets(nb = 5)
    if params['search'].blank?
      all_tweets = []
      @accounts.find_each do |account|
        all_tweets += TwitterClient.get_tweets(account.account).first(nb)
      end

      all_tweets.sort_by!(&:created_at)

      all_tweets.first(nb)
    else
      []
    end
  end

  def without_segments
    @posts = NewsFeed.all_links_without_segments(@group.news_feed.id, @group.enterprise)
    prune_posts
  end

  def with_segments
    segment_ids = current_user.segment_ids

    return without_segments if segment_ids.empty?

    @posts = NewsFeed.all_links(@group.news_feed.id, segment_ids, @group.enterprise)
    prune_posts
  end

  def prune_posts
    search_terms = split_search_terms
    if search_terms.present?
      @posts = @posts.search(search_terms)
    end
    @count = @posts.size
    @posts = @posts.order(is_pinned: :desc, created_at: :desc)
               .limit(@limit)
  end

  def filter_posts(posts)
    @posts = posts.includes([:news_link, :group_message, :social_link]).select { |news|
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@group.name}'s News Feed"
    when 'pending'
      "#{@group.name}'s Pending Posts"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
