class QuestionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_campaign, only: [:index, :new, :create]
  before_action :set_question, only: [:edit, :update, :destroy, :show, :reopen]

  layout "unify"

  def index
    @questions = @campaign.questions.order(created_at: :desc)
  end

  def new
    @question = @campaign.questions.new
  end

  def create
    @question = @campaign.questions.new(question_params)

    if @question.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def reopen
    @question.update(solved_at: nil)
    redirect_to :back
  end

  def update
    @question.solved_at = Time.now if question_params[:conclusion].present?

    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to action: :index
  end

  protected

  def set_campaign
    @campaign = current_admin.enterprise.campaigns.find(params[:campaign_id])
  end

  def set_question
    @question = current_admin.enterprise.questions.find(params[:id])
  end

  def question_params
    params
    .require(:question)
    .permit(
      :title,
      :conclusion,
      :description
    )
  end
end
