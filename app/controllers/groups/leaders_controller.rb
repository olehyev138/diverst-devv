class Groups::LeadersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group, :leaders?

    @group_leaders = @group.group_leaders
  end

  def new
    authorize @group, :leaders?
  end

  def create
    authorize @group, :leaders?
    if @group.update(group_params)
      @group.set_default_group_contact
      flash[:notice] = "Leaders were updated"
      redirect_to action: :index
    else
      flash[:alert] = "Leaders were not updated. Please fix the errors"
      render :new
    end
  end

  protected

  def set_group
    current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
  end

  def group_params
    params.require(:group).permit(group_leaders_attributes: [:id, :user_id, :position_name, :role, :_destroy, :visible, :pending_member_notifications_enabled, :pending_comments_notifications_enabled, :pending_posts_notifications_enabled, :default_group_contact])
  end
end
