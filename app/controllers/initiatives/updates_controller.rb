class Initiatives::UpdatesController < ApplicationController
  before_action :set_group
  before_action :set_initiative
  before_action :set_update, only: [:edit, :update, :destroy, :show, :export_csv]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize InitiativeUpdate
    @updates = @initiative.updates.order(report_date: :desc)
  end

  def new
    authorize InitiativeUpdate
    @update = @initiative.updates.new
  end

  def create
    authorize InitiativeUpdate

    @update = @initiative.updates.new( initiative_update_params)
    @update.info.merge(fields: @initiative.fields, form_data: params['custom-fields'])
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
    @update.info.merge(fields: @initiative.fields, form_data: params['custom-fields'])

    if @update.update(initiative_update_params)
      redirect_to action: :index
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

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_initiative
    @initiative = Initiative.find(params[:initiative_id])
  end

  def set_update
    @update = @initiative.updates.find(params[:id])
  end

  def initiative_update_params
    params
      .require(:initiative_update)
      .permit(
        :report_date
      )
  end
end
