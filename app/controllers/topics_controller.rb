class TopicsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_topic, only: [:edit, :update, :destroy, :show]

  def index
    @topics = current_admin.enterprise.topics
  end

  def new
    @topic = current_admin.enterprise.topics.new
  end

  def create
    @topic = current_admin.enterprise.topics.new(topic_params)
    @topic.admin = current_admin

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
    @topic = current_admin.enterprise.topics.find(params[:id])
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