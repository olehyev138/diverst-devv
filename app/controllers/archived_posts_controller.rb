class ArchivedPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:restore, :destroy]
  after_action :visit_page, only: [:index]

  layout 'erg_manager'

  def index
    # get all news feed for current enterprise
    @posts = NewsFeed.archived_posts(current_user.enterprise).order(created_at: :desc)
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
  end

  def destroy
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    track_activity(@post.group_message || @post.news_link || @post.social_link, :destroy)
    @post.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def delete_all
    @posts = NewsFeed.archived_posts(current_user.enterprise)
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    @posts.destroy_all

    respond_to do |format|
      format.html { redirect_to :back, notice: 'all archived posts deleted' }
      format.js
    end
  end

  def restore_all
    @posts = NewsFeed.archived_posts(current_user.enterprise)
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy
    @posts.update_all(archived_at: nil)

    respond_to do |format|
      format.html { redirect_to :back, notice: 'all archived posts restored' }
      format.js
    end
  end

  def restore
    @post.update(archived_at: nil)
    track_activity(@post.group_message || @post.news_link || @post.social_link, :restore)
    authorize current_user.enterprise, :manage_posts?, policy_class: EnterprisePolicy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end


  private

  def set_post
    @post = NewsFeedLink.find(params[:id])
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Archived Post'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
