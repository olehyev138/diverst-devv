class MentoringInterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:edit, :update, :destroy]
  after_action :visit_page, only: [:index, :new, :edit]

  layout 'mentorship'

  def index
    authorize MentoringInterest
    @topics = current_user.enterprise.mentoring_interests
  end

  def new
    authorize MentoringInterest
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

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'Mentorship Topics'
    when 'new'
      'Mentorship Topic Creation'
    when 'edit'
      "Mentorship Topic Edit: #{@topic.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
