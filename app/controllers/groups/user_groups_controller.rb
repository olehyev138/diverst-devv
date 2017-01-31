class Groups::UserGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_user_group

  def update
    if @user_group.update(user_group_params)
      render json: true
    else
      render json: false, status: :unprocessable_entity
    end
  end

  private
  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_user_group
    @user_group = current_user.user_groups.find(params[:id])
  end

  def user_group_params
    params.require(:user_group).permit(:enable_notification)
  end
end
