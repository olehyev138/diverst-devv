class Initiatives::UpdatesController < ApplicationController
  before_action :set_initiative
  before_action :set_update, only: [:edit, :update, :destroy, :show, :export_csv]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize InitiativeUpdate
    @updates = policy_scope(InitiativeUpdate)
  end

  def new
    authorize InitiativeUpdate
    @update = @initiative.updates.new
    binding.pry
  end

  def create
    authorize InitiativeUpdate
    @update = @initiative.updates.new(update_params)
    @update.owner = current_user

    if @update.save
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    authorize @update
  end

  def edit
    authorize @update
  end

  def update
    authorize @update
    if @update.update(update_params)
      redirect_to @update
    else
      render :edit
    end
  end

  def destroy
    authorize @update
    @update.destroy
    redirect_to action: :index
  end

  protected

  def set_initiative
    @initiative = current_user.enterprise.initiatives.find(params[:initiative_id])
  end

  def set_update
    @update = @initiative.updates.find(params[:id])
  end

  def update_params
    params
      .require(:update)
      .permit(

      )
  end
end
