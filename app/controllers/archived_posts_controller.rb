class ArchivedPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_enterprise

  layout 'erg_manager'

  def index
  	@posts = NewsFeed.archived_posts.order(created_at: :desc)
  end

  def show
  end

  def delete_all
  end

  def restore_all
  end

  def restore
  end


  protected

  def set_enterprise
  	@enterprise = Enterprise.find(params[:enterprise_id])
  end
end
