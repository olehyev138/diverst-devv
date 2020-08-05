class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_like, only: [:create, :unlike]

  include Rewardable

  def create
    if @like.blank?
      @like = Like.new
      @like.user = current_user
      if params[:news_feed_link_id].blank?
        @like.answer = Answer.find(params[:answer_id])
        answer_upvote = AnswerUpvote.create(answer_id: params[:answer_id], author_id: current_user.id)
        user_rewarder('campaign_vote').add_points(answer_upvote)
      else
        @like.news_feed_link = NewsFeedLink.find(params[:news_feed_link_id])
        @like.news_feed_link.create_view_if_none(current_user)
      end
      @like.enterprise = current_user.enterprise
      @like.save!
    end

    render json: { like_success: @like.persisted? }
  end

  def unlike
    @like.destroy
    @answer_upvote.destroy

    render json: { unlike_success: @like.destroyed? }
  end

  protected

  def set_like
    if params[:news_feed_link_id].blank?
      @like = Like.find_by(user: current_user, answer_id: params[:answer_id], enterprise: current_user.enterprise)
      @answer_upvote = AnswerUpvote.find_by(answer_id: params[:answer_id], author_id: current_user.id)
    else
      @like = Like.find_by(user: current_user, news_feed_link_id: params[:news_feed_link_id], enterprise: current_user.enterprise)
    end
  end

  def like_params
    params.require(:like).permit(
      :news_feed_link_id,
      :answer_id
    )
  end
end
