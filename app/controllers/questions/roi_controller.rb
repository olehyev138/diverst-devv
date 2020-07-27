class Questions::RoiController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answers

  layout 'collaborate'

  def edit
    @departments = current_user.enterprise.departments
    @business_impacts = current_user.enterprise.business_impacts
  end

  protected

  def set_question
    @question = current_user.enterprise.questions.find(params[:question_id])
  end

  def set_answers
    @answers = @question.answers.where(chosen: true).includes(:author)
  end
end
