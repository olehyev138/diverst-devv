class Groups::UpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_update, only: [:edit, :update, :destroy, :show]
  after_action :verify_authorized

  layout 'plan'

  def index
    authorize current_user.policy_group.groups_manage?
    @updates = @group.updates
  end

  def new
    authorize current_user.policy_group.groups_manage?
    @update = @group.updates.new
  end

  def create
    authorize current_user.policy_group.groups_manage?
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
    authorize current_user.policy_group.groups_manage?
  end

  def edit
    authorize current_user.policy_group.groups_manage?
  end

  def update
    authorize current_user.policy_group.groups_manage?
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
    authorize current_user.policy_group.groups_manage?
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
