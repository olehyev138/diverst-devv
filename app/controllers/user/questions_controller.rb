class User::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:index, :new, :create]
  before_action :set_question, only: [:edit, :update, :destroy, :show, :reopen]
  after_action :visit_page, only: [:index, :show]

  layout 'user'

  def index
    @questions = @campaign.questions.order(created_at: :desc)
    @sponsors = @campaign.sponsors
  end

  def show
    @answers = @question.answers
      .includes(:author, comments: :author)
      .order(chosen: :desc)
      .order(upvote_count: :desc)
    @categories = IdeaCategory.where(enterprise_id: current_user.enterprise_id)  
    @answer = @question.answers.new
  end

  protected

  def set_campaign
    @campaign = current_user.enterprise.campaigns.find(params[:user_campaign_id])
  end

  def set_question
    @question = current_user.enterprise.questions.find(params[:id])
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'User\'s Campaigns Questions'
    when 'show'
      'User\'s Campaigns Answer'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end
