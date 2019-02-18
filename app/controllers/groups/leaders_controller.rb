class Groups::LeadersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize [@group], :index?, :policy_class => GroupLeaderPolicy
    @group_leaders = @group.group_leaders
  end

  def new
    authorize [@group], :new?, :policy_class => GroupLeaderPolicy
  end

  def create
    authorize [@group], :create?, :policy_class => GroupLeaderPolicy
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
    params.require(:group).permit(group_leaders_attributes: [:id, :position, :user_id, :position_name, :user_role_id, :_destroy, :visible, :pending_member_notifications_enabled, :pending_comments_notifications_enabled, :pending_posts_notifications_enabled, :default_group_contact])
  end
end
