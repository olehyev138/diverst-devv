class Employee::QuestionsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_campaign, only: [:index, :new, :create]
  before_action :set_question, only: [:edit, :update, :destroy, :show, :reopen]

  layout "employee"

  def index
    @questions = @campaign.questions.order(created_at: :desc)
  end

  protected

  def set_campaign
    @campaign = current_employee.enterprise.campaigns.find(params[:campaign_id])
  end

  def set_question
    @question = current_employee.enterprise.questions.find(params[:id])
  end
end
