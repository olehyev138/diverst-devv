class Groups::GroupMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_member, only: [:edit, :update, :destroy]

  layout "erg"

  def index
    @members = @group.members.page(params[:page])
  end

  # Removes a member from the group
  def destroy
    @group.members.delete(@member)
    redirect_to :back
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_member
    @member = @group.members.find(params[:id])
  end
end
