class User::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:index, :new, :create]
  before_action :set_question, only: [:edit, :update, :destroy, :show, :reopen]

  layout 'user'

  def index
    visit_page('User\'s Campaigns Questions')
    @questions = @campaign.questions.order(created_at: :desc)
    @sponsors = @campaign.sponsors
  end

  def show
    visit_page('User\'s Campaigns Answer')
    @answers = @question.answers
      .includes(:author, comments: :author)
      .order(chosen: :desc)
      .order(upvote_count: :desc)
    @answer = @question.answers.new
  end

  protected

  def set_campaign
    @campaign = current_user.enterprise.campaigns.find(params[:user_campaign_id])
  end

  def set_question
    @question = current_user.enterprise.questions.find(params[:id])
  end
end
