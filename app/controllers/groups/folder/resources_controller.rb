class Groups::Folder::ResourcesController < ApplicationController
  include IsResources

  layout 'erg'

  def archive
    super
  end

  def restore
    super
  end

  protected

  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_container
    set_group
    @folder = @container = @group.folders.find_by_id(params[:folder_id]) || @group.shared_folders.find_by_id(params[:folder_id])
    raise ActiveRecord::RecordNotFound if @folder.nil?
  end

  def set_container_path
    @container_path = [@group, @folder]
  end
end
