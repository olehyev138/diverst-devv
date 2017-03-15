class Groups::UpdatesController < ApplicationController
  before_action :set_group
  before_action :set_update, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize @group, :show?
    @updates = @group.updates
  end

  def new
    authorize @group, :show?
    @update = @group.updates.new
  end

  def create
    authorize @group, :show?
    @update = @group.updates.new(update_params.merge({ owner_id: current_user.id }))
    @update.info.merge(fields: @group.fields, form_data: params['custom-fields'])

    if @update.save
      flash[:notice] = "Your group update was created"
      redirect_to action: :index
    else
      flash[:alert] = "Your group update was not created. Please fix the errors"
      render :new
    end
  end

  def show
    authorize @group, :show?
  end

  def edit
    authorize @group, :show?
  end

  def update
    authorize @group, :show?
    @update.info.merge(fields: @group.fields, form_data: params['custom-fields'])

    if @update.update(update_params)
      flash[:notice] = "Your group update was updated"
      redirect_to action: :index
    else
      flash[:alert] = "Your group update was not updated. Please fix the errors"
      render :edit
    end
  end

  def destroy
    authorize @group, :show?
    @update.destroy
    redirect_to action: :index
  end

  protected

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_update
    @update = @group.updates.find(params[:id])
  end

  def update_params
    params.require(:group_update).permit(:created_at)
  end
end
