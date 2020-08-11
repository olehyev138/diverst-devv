class User::UserAnswersController < ApplicationController
  include Rewardable

  before_action :authenticate_user!
  before_action :set_question, except: [:vote]
  before_action :set_answer, only: [:vote]

  layout 'user'

  def vote
    return head 403 unless @answer.question.solved_at.nil?
    return head 403 if @answer.author == current_user # Cant vote on your own answer

    if vote_params[:upvoted] == 'true'
      @vote = AnswerUpvote.find_or_create_by(author_id: current_user.id, answer_id: @answer.id)
    else
      @vote = AnswerUpvote.where(author_id: current_user.id, answer_id: @answer.id).first
      @vote.destroy if @vote
    end

    user_rewarder('campaign_vote').add_points(@vote) if @vote

    flash_reward "Now you have #{current_user.credits} points"
    render 'partials/flash_messages.js'
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      user_rewarder('campaign_answer').add_points(@answer)
      track_activity(@answer, :create)
      flash_reward "Your answer was created. Now you have #{current_user.credits} points"
    else
      flash[:alert] = 'Your answer was not created. Please fix the errors'
    end

    redirect_to [:user, @campaign, @question]
  end


  protected

  def set_question
    @question = current_user.enterprise.questions.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    return head 403 if @answer.question.campaign.users.where(id: current_user.id).count < 1
  end

  def vote_params
    params
      .require(:answer)
      .permit(
        :upvoted
      )
  end

  def answer_params
    params
      .require(:answer)
      .permit(
        :title,
        :content,
        :idea_category_id,
        :contributing_group_id,
        :supporting_document,
        :video_upload
      )
  end
end
