class Groups::Folder::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'erg'

  protected
  
  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_container
    set_group
    @folder = @container = @group.folders.find_by_id(params[:folder_id]) || @group.shared_folders.find_by_id(params[:folder_id])
  end

  def set_container_path
    @container_path = [@group, @folder]
  end
end
