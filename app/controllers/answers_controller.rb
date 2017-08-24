class AnswersController < ApplicationController
  before_action :set_answer

  layout 'collaborate'

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head 500
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question
  end

  protected

  def set_answer
    @answer = current_user.enterprise.answers.find(params[:id])
    @question = @answer.question
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
