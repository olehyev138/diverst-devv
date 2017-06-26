class Groups::LeadersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group, :update?

    @group_leaders = @group.group_leaders
  end

  def new
    authorize @group, :update?
  end

  def create
    authorize @group, :update?
    if @group.update(group_params)
      flash[:notice] = "Leaders were updated"
      redirect_to action: :index
    else
      flash[:alert] = "Leaders were not updated. Please fix the errors"
      render :new
    end
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def group_params
    params.require(:group).permit(group_leaders_attributes: [:id, :user_id, :position_name, :_destroy, :visible])
  end
end
