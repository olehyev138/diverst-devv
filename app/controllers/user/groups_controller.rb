class User::GroupsController < ApplicationController
  before_action :authenticate_user!

  layout 'user'

  def index
    @groups = current_user.enterprise.groups
  end

  def join
    @group = current_user.enterprise.groups.find(params[:id])
    return if @group.members.include? current_user
    @group.members << current_user
    @group.save
  end

  def enable_notifications
    user_group = UserGroup.where(user_id: current_user.id, group_id: params[:id]).first
    if !user_group
      render json: false, status: :not_found
    else
      user_group.update(enable_notification: params[:enable_notification])
      render json: true
    end
  end
end
