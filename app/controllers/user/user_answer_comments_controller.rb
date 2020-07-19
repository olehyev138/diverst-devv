class User::UserAnswerCommentsController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_answer

  layout 'user'

  def create
    @comment = @answer.comments.new(comment_params)
    @comment.author = current_user
    if @comment.save
      user_rewarder('campaign_comment').add_points(@comment)
      track_activity(@comment, :create)
      flash_reward "Your comment was created. Now you have #{current_user.credits} points"
    else
      flash[:alert] = 'Your comment was not created. Please fix the errors'
    end

    redirect_to [:user, @answer.question]
  end

  protected

  def author_of_campaign_or_idea
    current_user.enterprise.campaigns.where(owner: current_user).count > 1 || @answer.author == current_user
  end

  def set_answer
    @answer = Answer.find(params[:user_answer_id])
    return head 403 if author_of_campaign_or_idea
  end

  def comment_params
    params
        .require(:answer_comment)
        .permit(
          :content
        )
  end
end
