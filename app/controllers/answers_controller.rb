class AnswersController < ApplicationController
  before_action :authenticate_user!
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
    if current_user
      @answer = current_user.enterprise.answers.find(params[:id])
      @question = @answer.question
    else
      user_not_authorized
    end
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
