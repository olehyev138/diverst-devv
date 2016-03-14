class Questions::RoiController < ApplicationController
  before_action :set_question
  before_action :set_answers

  layout 'collaborate'

  protected

  def set_question
    @question = current_user.enterprise.questions.find(params[:question_id])
  end

  def set_answers
    @answers = @question.answers.where(chosen: true)
  end

  def answer_params
    params
      .require(:question)
      .permit(
        answers_attributes: [
          :id,
          :outcome,
          :value,
          :benefit_type
        ]
      )
  end
end
