class ArchivedPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:restore, :destroy]

  layout 'erg_manager'

  def index
  	@posts = NewsFeed.archived_posts.order(created_at: :desc)
  end

  def destroy
    @post.destroy
    redirect_to :back
  end

  def delete_all
    @posts = NewsFeed.archived_posts
    @posts.delete_all
    redirect_to :back, notice: 'all archived posts deleted'
  end

  def restore_all
    @posts = NewsFeed.archived_posts
    @posts.update_all(archived_at: nil)
    redirect_to :back, notice: 'all archived posts restored'
  end

  def restore
    @post.update archived_at: nil
    redirect_to :back
  end


  private

  def set_post
    @post = NewsFeedLink.find(params[:id])
  end
end
