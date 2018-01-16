class Groups::FoldersController < ApplicationController
  include Folders

  before_action :authenticate_user!

  layout 'erg'

  def index
    if policy(@group).erg_leader_permissions? or @group.active_members.include? current_user
      super
    else
      @folders = []
      render '/index'
    end
  end

  protected

  def set_container
    if current_user
      @group = @container = current_user.enterprise.groups.find(params[:group_id])
    else
      user_not_authorized
    end
  end

  def set_container_path
    @container_path = [@group]
  end
end
