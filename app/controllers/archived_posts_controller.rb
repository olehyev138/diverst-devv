class ArchivedPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :restore, :destroy]

  layout 'erg_manager'

  def index
  	@posts = NewsFeed.archived_posts.order(created_at: :desc)
  end

  def show
  end

  def destroy
  end

  def delete_all
  end

  def restore_all
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
