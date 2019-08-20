class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:index, :new, :create]
  before_action :set_question, only: [:edit, :update, :destroy, :show, :reopen]
  after_action :verify_authorized
  after_action :visit_page, only: [:index, :new, :show, :edit]

  layout 'collaborate'

  def index
    authorize @campaign
    @questions = @campaign.questions.order(created_at: :desc)
  end

  def new
    authorize @campaign
    @question = @campaign.questions.new
  end

  def show
    authorize @question.campaign
    @answers = @question.answers
      .includes(:author, comments: :author)
      .order(chosen: :desc)
      .order(upvote_count: :desc)
  end

  def create
    authorize @campaign
    @question = @campaign.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question was created'
      track_activity(@question, :create)
      redirect_to action: :index
    else
      flash[:alert] = 'Your question was not created. Please fix the errors'
      render :new
    end
  end

  def reopen
    authorize @question.campaign, :edit?
    @question.update(solved_at: nil)
    redirect_to :back
  end

  def edit
    authorize @question.campaign
  end

  def update
    authorize @question.campaign
    @question.solved_at = Time.current if question_params[:conclusion].present?

    if @question.update(question_params)
      flash[:notice] = 'Your question was updated'
      track_activity(@question, :update)
      redirect_to @question
    else
      flash[:alert] = 'Your question was not updated. Please fix the errors'
      render :edit
    end
  end

  def destroy
    authorize @question.campaign
    track_activity(@question, :destroy)
    @question.destroy
    redirect_to :back
  end

  protected

  def set_campaign
    @campaign = current_user.enterprise.campaigns.find(params[:campaign_id])
  end

  def set_question
    @question = current_user.enterprise.questions.find(params[:id])
  end

  def question_params
    params
      .require(:question)
      .permit(
        :title,
        :conclusion,
        :description,
        answers_attributes: [
          :id,
          :outcome,
          :value,
          :benefit_type,
          :supporting_document,
          expenses_attributes: [
            :id,
            :_destroy,
            :expense_id,
            :quantity
          ]
        ]
      )
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      "#{@campaign.to_label} Questions"
    when 'new'
      "Create Question for #{@campaign.to_label}"
    when 'show'
      "#{@question.campaign.to_label} Question: #{@question.to_label}"
    when 'edit'
      "#{@question.campaign.to_label} Question Edit: #{@question.to_label}"
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
