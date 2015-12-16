class Employee::AnswerCommentsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_answer

  layout "employee"

  def create
    @comment = @answer.comments.new(comment_params)
    @comment.author = current_employee
    @comment.save

    redirect_to [:employee, @answer.question]
  end

  protected

  def set_answer
    @answer = Answer.find(params[:answer_id])
    return head 403 if @answer.question.campaign.employees.where(id: current_employee.id).count < 1
  end

  def comment_params
    params
    .require(:answer_comment)
    .permit(
      :content
    )
  end
end