class Employee::AnswersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_campaign, except: [:vote]
  before_action :set_question, except: [:vote]
  before_action :set_answer, only: [:vote]

  layout "employee"

  def vote
    return head 403 if !@answer.question.solved_at.nil?
    return head 403 if @answer.author == current_employee # Cant vote on your own answer

    if vote_params[:upvoted] == "true"
      AnswerUpvote.find_or_create_by(author_id: current_employee.id, answer_id: @answer.id)
    else
      vote = AnswerUpvote.where(author_id: current_employee.id, answer_id: @answer.id).first
      vote.destroy if vote
    end

    head 200
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_employee
    @answer.save

    redirect_to [:employee, @campaign, @question]
  end

  protected

  def set_campaign
    @campaign = current_employee.enterprise.campaigns.find(params[:campaign_id])
  end

  def set_question
    @question = @campaign.questions.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    return head 403 if @answer.question.campaign.employees.where(id: current_employee.id).count < 1
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