class TopicFeedbacksController < ApplicationController
  before_action :authenticate_employee!, except: [:destroy]
  before_action :authenticate_admin!, only: [:destroy]
  before_action :set_topic
  before_action :set_feedback, only: [:update, :destroy, :show]

  layout "guest"

  def new
    @feedback = @topic.feedbacks.new
  end

  def create
    @feedback = @topic.feedbacks.new(feedback_params)
    @feedback.employee = current_employee

    if @feedback.save
      redirect_to action: :thank_you
    else
      render :edit
    end
  end

  def destroy
    @feedback.destroy
    redirect_to :back
  end

  def update
    if @feedback.update(admin_feedback_params)
      head :ok
    else
      head :internal_server_error
    end
  end

  protected

  def set_topic
    @topic = current_employee.enterprise.topics.find(params[:topic_id])
  end

  def set_feedback
    @feedback = @topic.feedbacks.find(params[:id])
  end

  def feedback_params
    params
    .require(:topic_feedback)
    .permit(
      :content
    )
  end

  def admin_feedback_params
    params
    .require(:topic_feedback)
    .permit(
      :content,
      :featured
    )
  end
end