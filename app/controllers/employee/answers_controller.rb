class Employee::AnswersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_campaign, except: [:vote]
  before_action :set_question, except: [:vote]
  before_action :set_answer, only: [:vote]

  layout "employee"

  def vote
    if vote_params[:upvoted] == "true"
      AnswerUpvote.find_or_create_by(employee_id: current_employee.id, answer_id: @answer.id)
    else
      vote = AnswerUpvote.where(employee_id: current_employee.id, answer_id: @answer.id).first
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
    @answer = current_employee.answers.find(params[:id])
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