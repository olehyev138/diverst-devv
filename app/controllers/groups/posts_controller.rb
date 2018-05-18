class Groups::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_page,    :only => [:index, :pending]
  before_action :set_link,    :only => [:approve, :pin, :unpin]

  layout 'erg'

  def index
    if policy(@group).erg_leader_permissions?
      @count = NewsFeedLink.leader_links_count(@group)
      @posts = NewsFeedLink.leader_links(@group, @limit)
    elsif @group.active_members.include? current_user
      @count = NewsFeedLink.user_links_count(@group, current_user)
      @posts = NewsFeedLink.user_links(@group, current_user, @limit)
    else
      @count = 0
      @posts = []
    end
  end

  def pending
    @posts = @group.news_feed_links.includes(:link).not_approved.order(created_at: :desc)
  end

  def approve
    @link.approved = true
    if not @link.save
      flash[:alert] = "Link not approved"
    end
    redirect_to :back
  end

  def pin
    @link.is_pinned = true
    if !@link.save
      flash[:alert] = "Link was not pinned"
    end
    redirect_to :back
  end

  def unpin
    @link.is_pinned = false
    if !@link.save
      flash[:alert] = "Link was not unpinned"
    end
    redirect_to :back
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
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
