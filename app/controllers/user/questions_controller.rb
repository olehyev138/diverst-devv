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
  end

  protected

  def set_campaign
    @campaign = current_user.enterprise.campaigns.find(params[:campaign_id])
  end

  def set_question
    @question = current_user.enterprise.questions.find(params[:id])
  end
end
