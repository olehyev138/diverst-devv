class NewsFeedLikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @news_feed_like = NewsFeedLike.find_by(:user => current_user, :news_feed_link => params[:news_feed_link_id])

    if @news_feed_like.blank?
      @news_feed_like = NewsFeedLike.new
      @news_feed_like.user = current_user
      @news_feed_like.news_feed_link = NewsFeedLink.find(params[:news_feed_link_id])
      @news_feed_like.save
    end

    render json: @news_feed_like.present?
  end

  def unlike
    @news_feed_like = NewsFeedLike.find_by(:user => current_user, :news_feed_link => params[:news_feed_link_id])

    @news_feed_like.destroy

    render json: !@news_feed_like.destroyed?
  end

  protected
    def news_feed_like_params
      params.require(:news_feed_like).permit(
        :news_feed_link_id,
      )
    end
end
