class AnswersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_campaign
  before_action :set_question

  layout "unify"

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_employee
    @answer.save

    redirect_to [@campaign, @question]
  end

  protected

  def set_campaign
    @campaign = current_employee.enterprise.campaigns.find(params[:campaign_id])
  end

  def set_question
    @question = @campaign.questions.find(params[:question_id])
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