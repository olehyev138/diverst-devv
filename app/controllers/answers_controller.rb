class AnswersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_answer, only: [:vote]

  layout "market_scope"

  def vote
    if vote_params[:upvoted] == "true"
      AnswerUpvote.find_or_create_by(employee_id: current_employee.id, answer_id: @answer.id)
    else
      vote = AnswerUpvote.where(employee_id: current_employee.id, answer_id: @answer.id).first
      pp vote
      vote.destroy if vote
    end

    head 200
  end

  protected

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
end