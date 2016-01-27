class AnswersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_answer

  layout 'unify'

  def update
    if @answer.update(answer_params)
      head 200
    else
      head 500
    end
  end

  protected

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
