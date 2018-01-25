class Groups::LeadersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :check_for_multiple_group_contacts, only: [:create]
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
      set_group_contact
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

  def all_group_leaders_contacts_set?
    count = params[:group][:group_leaders_attributes].count - 1
    (0..count).all? { |i| params[:group][:group_leaders_attributes][i.to_s][:set_email_as_group_contact] == "1" }
  end

  def subset_group_leaders_contact_set_greater_than_one?
    count = params[:group][:group_leaders_attributes].count
    @counter = 0
    params[:group][:group_leaders_attributes].each do |key, value|
      @counter += 1 if value["set_email_as_group_contact"] == "1"
      break if @counter > 1
    end
    return true if @counter > 1
    return false if @counter == 1
  end

  def check_for_multiple_group_contacts
    set_group
    if all_group_leaders_contacts_set? || subset_group_leaders_contact_set_greater_than_one?
      flash.now[:alert] = "You can set ONLY ONE email as group contact"
      render :new 
    end
  end

  def set_group_contact
    @group_leader = @group.group_leaders.find_by(set_email_as_group_contact: true)&.user
    @group.update(contact_email: @group_leader&.email)
  end

  def group_params
    params.require(:group).permit(group_leaders_attributes: [:id, :user_id, :position_name, :_destroy, :visible, :pending_member_notifications_enabled, :pending_comments_notifications_enabled, :pending_posts_notifications_enabled, :set_email_as_group_contact])
  end
end
