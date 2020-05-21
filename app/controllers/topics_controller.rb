class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:edit, :update, :destroy, :show]

  layout 'handshake'
  # NOTE: this layout does not exist in views/layout. This controller does not have a corresponding spec file

  def index
    @topics = current_user.enterprise.topics
  end

  def new
    @topic = current_user.enterprise.topics.new
  end

  def create
    @topic = current_user.enterprise.topics.new(topic_params)
    @topic.admin = current_user

    if @topic.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def update
    if @topic.update(topic_params)
      redirect_to @topic
    else
      render :edit
    end
  end

  def destroy
    @topic.destroy
    redirect_to action: :index
  end

  protected

  def set_topic
    @topic = current_user.enterprise.topics.find(params[:id])
  end

  def topic_params
    params
      .require(:topic)
      .permit(
        :statement,
        :expiration
      )
  end
end
