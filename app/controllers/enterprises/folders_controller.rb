class Enterprises::FoldersController < ApplicationController
  include Folders

  before_action :authenticate_user!
  
  layout 'erg_manager'
  
  protected

  def set_container
    @enterprise = @container = Enterprise.find(params[:enterprise_id])
  end

  def set_container_path
    @container_path = [@enterprise]
  end
  
  def authorize_action
    authorize ::Folder
  end
end
