class OutcomesController < ApplicationController
  before_action :set_group
  before_action :set_outcome, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize Outcome
  end

  def new
    authorize Outcome
    @outcome = Outcome.new
  end

  def create
    authorize Outcome
    @outcome = Outcome.new(outcome_params)
    @outcome.enterprise = current_user.enterprise
    @outcome.estimated_funding *= 100
    @outcome.owner = current_user

    if @outcome.save
      flash[:notice] = "Your #{ c_t(:outcome) } was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your #{ c_t(:outcome) } was not created. Please fix the errors"
      render :new
    end
  end

  def edit
    authorize @outcome
  end

  def update
    authorize @outcome
    if @outcome.update(outcome_params)
      flash[:notice] = "Your #{ c_t(:outcome) } was updated"
      redirect_to @outcome
    else
      flash[:alert] = "Your #{ c_t(:outcome) } was not updated. Please fix the errors"
      render :edit
    end
  end

  def destroy
    authorize @outcome
    @outcome.destroy
    redirect_to action: :index
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.includes(outcomes: :pillars).find(params[:group_id])
  end

  def set_outcome
    @outcome = current_user.enterprise.outcomes.find(params[:id])
  end

  def outcome_params
    params
      .require(:outcome)
      .permit(

      )
  end
end
