class MentoringInterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:edit, :update, :destroy]

  layout 'mentorship'

  def index
    authorize MentoringInterest
    visit_page('Mentorship Topics')
    @topics = current_user.enterprise.mentoring_interests
  end

  def new
    authorize MentoringInterest
    visit_page('Mentorship Topic Creation')
    @topic = current_user.enterprise.mentoring_interests.new
  end

  def create
    authorize MentoringInterest
    @topic = current_user.enterprise.mentoring_interests.new(topic_params)

    if @topic.save
      flash[:notice] = 'Your topic was created'
      redirect_to action: :index
    else
      flash[:alert] = 'Your topic was not created. Please fix the errors'
      render :new
    end
  end

  def edit
    authorize MentoringInterest
    visit_page("Mentorship Topic Edit: #{@topic.name}")
  end

  def update
    authorize MentoringInterest

    if @topic.update(topic_params)
      flash[:notice] = 'The topic was updated'
      redirect_to action: :index
    else
      flash[:alert] = 'The topic was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize MentoringInterest
    @topic.destroy
    redirect_to :back
  end

  private

  def set_topic
    @topic = current_user.enterprise.mentoring_interests.find(params[:id])
  end

  def topic_params
    params
      .require(:mentoring_interest)
      .permit(
        :name
      )
  end
end
