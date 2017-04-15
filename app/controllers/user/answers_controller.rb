class User::AnswersController < ApplicationController
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
    user_rewarder("campaign_vote").add_points(@vote)

    head 200
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save && user_rewarder("campaign_answer").add_points(@answer)
    flash[:reward] = "Your answer was created. Now you have #{ current_user.credits } points"

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
        :content
      )
  end
end
