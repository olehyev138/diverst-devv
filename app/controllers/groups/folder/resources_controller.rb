class Groups::Folder::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'erg'

  protected

  def set_group
    if current_user
      @group = current_user.enterprise.groups.find(params[:group_id])
    else
      user_not_authorized
    end
  end

  def set_container
    if current_user
      set_group
      @folder = @container = @group.folders.find_by_id(params[:folder_id]) || @group.shared_folders.find_by_id(params[:folder_id])
    else
      user_not_authorized
    end
  end

  def set_container_path
    @container_path = [@group, @folder]
  end
end
