class ArchivedPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:restore, :destroy]

  layout 'erg_manager'

  def index
    # get all news feed for current enterprise
  	@posts = NewsFeed.archived_posts(current_user.enterprise).order(created_at: :desc)
  end

  def destroy
    @post.destroy
    redirect_to :back
  end

  def delete_all
    @posts = NewsFeed.archived_posts(current_user.enterprise)
    @posts.delete_all
    redirect_to :back, notice: 'all archived posts deleted'
  end

  def restore_all
    @posts = NewsFeed.archived_posts(current_user.enterprise)
    @posts.update_all(archived_at: nil)
    
    respond_to do |format|
      format.html { redirect_to :back, notice: 'all archived posts restored' }
      format.js
    end
  end

  def restore
    @post.update(archived_at: nil)
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end


  private

  def set_post
    @post = NewsFeedLink.find(params[:id])
  end
end
