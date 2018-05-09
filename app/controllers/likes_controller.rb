class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_like

  def create
    if @like.blank?
      @like = Like.new
      @like.user = current_user
      @like.news_feed_link = NewsFeedLink.find(params[:news_feed_link_id])
      @like.enterprise = current_user.enterprise
      @like.save
    end

    render json: { :like_success => @like.present? }
  end

  def unlike
    @like.destroy

    render json: { :unlike_success => @like.destroyed? }
  end

  protected
    def like_params
      params.require(:like).permit(
        :news_feed_link_id,
      )
    end

    def set_like
      @like = Like.find_by(:user => current_user, :news_feed_link => params[:news_feed_link_id], :enterprise => current_user.enterprise)
    end
end
