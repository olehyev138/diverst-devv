class Enterprises::Folder::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'erg_manager'

  protected
  
  def set_enterprise
    @enterprise = Enterprise.find(params[:enterprise_id])
  end

  def set_container
    set_enterprise
    @folder = @container = @enterprise.folders.find(params[:folder_id])
  end

  def set_container_path
    @container_path = [@enterprise, @folder]
  end
end
