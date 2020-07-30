class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update]

  layout 'collaborate'

  def update
    if answer_params[:chosen] == 'true'
      @answer.update(chosen: true)
    else
      @answer.update(chosen: false)
    end

    render nothing: true
  end


  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:chosen)
  end
end
