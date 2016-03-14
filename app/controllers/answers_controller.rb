class AnswersController < ApplicationController
  before_action :set_answer

  layout 'collaborate'

  def update
    if @answer.update(answer_params)
      head 200
    else
      head 500
    end
  end

  protected

  def set_answer
    @answer = current_user.enterprise.answers.find(params[:id])
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
