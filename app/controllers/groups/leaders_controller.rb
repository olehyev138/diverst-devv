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
      set_group_leader_email_as_group_contact
    else
      flash[:alert] = "Leaders were not updated. Please fix the errors"
      render :new
    end
  end

  protected

  def set_group
    current_user ? @group = current_user.enterprise.groups.find(params[:group_id]) : user_not_authorized
  end

  def set_group_leader_email_as_group_contact
    if @group.group_leaders.where(group_contact: true).count > 1
      flash.now[:alert] = "You can choose ONLY ONE email as contact of #{@group.name}"
      render :new
    else
      group_leader = @group.group_leaders.find_by(group_contact: true)&.user
      @group.update(contact_email: group_leader&.email)
      flash[:notice] = "Leaders were updated" if @group.contact_email.nil?
      flash[:notice] = "Leaders were updated. #{group_leader&.email} set as group contact for #{@group.name}" unless @group.contact_email.nil?
      redirect_to action: :index
    end
  end

  def group_params
    params.require(:group).permit(group_leaders_attributes: [:id, :user_id, :position_name, :_destroy, :visible, :pending_member_notifications_enabled, :pending_comments_notifications_enabled, :pending_posts_notifications_enabled, :group_contact])
  end
end
