class Groups::GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_member, only: [:edit, :update, :destroy,:accept_pending, :remove_member]
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group, :view_members?
    @q = User.ransack(params[:q])
    @total_members = @group.active_members.count
    @members = @group.active_members.ransack(params[:q]).result.uniq
    @segments = @group.enterprise.segments
    respond_to do |format|
      format.html
      format.json { render json: GroupMemberDatatable.new(view_context, @group, @members) }
    end
  end

  def pending
    authorize @group, :manage_members?

    @pending_members = @group.pending_members.page(params[:page])
  end

  def accept_pending
    authorize @group, :manage_members?

    @group.accept_user_to_group(@member)

    redirect_to action: :pending
  end

  def new
    #TODO only show enterprise users not currently in group
    authorize @group, :manage_members?
  end

  # Removes a member from the group
  def destroy
    authorize @member, :join_or_leave_groups?
    @group.members.delete(@member)
    redirect_to group_path(@group)
  end

  def create
    authorize current_user, :join_or_leave_groups?
    @group_member = @group.user_groups.new(group_member_params)

    if @group_member.save
      flash[:notice] = "The member was created"
      redirect_to :back
    else
      flash[:notice] = "The member was not created. Please fix the errors"
      render :new
    end
  end

  def add_members
    authorize @group, :manage_members?

    add_members_params[:member_ids].each do |user_id|
      user = User.find_by_id(user_id)

      # Only add association fif user exists and belongs to the same enterprise
      next if (!user) || (user.enterprise != @group.enterprise)
      next if @group.members.include? user

      @group.members << user
    end

    redirect_to action: 'index'
  end

  def remove_member
    authorize @group, :manage_members?
    @group.members.delete(@member)
    redirect_to action: :index
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_member
    @member = @group.members.find(params[:id])
  end

  def group_member_params
    params.require(:user).permit(
      :user_id
    )
  end

  def add_members_params
    params.require(:group).permit(
      member_ids: []
    )
  end
end
