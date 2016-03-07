class Groups::GroupMembersController < ApplicationController
  before_action :set_group
  before_action :set_member, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  layout 'erg'

  def index
    authorize @group, :show?
    @members = @group.members.page(params[:page])
  end

  # Removes a member from the group
  def destroy
    authorize @member, :join_or_leave_groups?
    @group.members.delete(@member)
    redirect_to :back
  end

  def create
    authorize current_user, :join_or_leave_groups?
    @group_member = @group.user_groups.new(group_member_params)

    if @group_member.save
      redirect_to :back
    else
      render :edit
    end
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
end
