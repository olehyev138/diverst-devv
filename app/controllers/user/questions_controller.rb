class User::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:index, :new, :create]
  before_action :set_question, only: [:edit, :update, :destroy, :show, :reopen]

  layout 'user'

  def index
    @questions = @campaign.questions.order(created_at: :desc)
  end

  def show
    @answers = @question.answers
      .includes(:author, comments: :author)
      .order(chosen: :desc)
      .order(upvote_count: :desc)
    @answer = @question.answers.new
  end

  protected

  def set_campaign
    current_user ? @campaign = current_user.enterprise.campaigns.find(params[:user_campaign_id]) : user_not_authorized
  end

  def set_question
    current_user ? @question = current_user.enterprise.questions.find(params[:id]) : user_not_authorized
  end
end
