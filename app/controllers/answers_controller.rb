class AnswersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_campaign, only: [:index, :new, :create]
  before_action :set_question, only: [:index, :new, :create]
  before_action :set_answer, except: [:index, :new]

  layout "unify"

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_employee
    @answer.save

    redirect_to @question
  end

  def update
    if @answer.update(answer_params)
      head 200
    else
      head 500
    end
  end

  protected

  def set_campaign
    @campaign = current_employee.enterprise.campaigns.find(params[:campaign_id])
  end

  def set_question
    @question = @campaign.questions.find(params[:question_id])
  end

  def set_answer
    @answer = current_admin.enterprise.answers.find(params[:id])
  end

  def answer_params
    params
    .require(:answer)
    .permit(
      :content,
      :chosen
    )
  end
end