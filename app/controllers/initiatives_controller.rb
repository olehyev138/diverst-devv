class InitiativesController < ApplicationController
  before_action :set_initiative, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize Initiative
    @initiatives = policy_scope(Initiative)
  end

  def new
    authorize Initiative
    @initiative = current_user.enterprise.initiatives.new
  end

  def create
    authorize Initiative
    @initiative = current_user.enterprise.initiatives.new(initiative_params)
    @initiative.owner = current_user

    if @initiative.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    authorize @initiative
  end

  def edit
    authorize @initiative
  end

  def update
    authorize @initiative
    if @initiative.update(initiative_params)
      redirect_to @initiative
    else
      render :edit
    end
  end

  def destroy
    authorize @initiative
    @initiative.destroy
    redirect_to action: :index
  end

  protected

  def set_initiative
    @initiative = current_user.enterprise.initiatives.find(params[:id])
  end

  def initiative_params
    params
      .require(:initiative)
      .permit(
        :title,
        :description
      )
  end
end
