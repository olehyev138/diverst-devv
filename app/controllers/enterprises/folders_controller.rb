class Enterprises::FoldersController < ApplicationController
  include Folders

  layout 'erg_manager'

  protected

  def set_container
    @enterprise = @container = Enterprise.find(params[:enterprise_id])
  end

  def set_container_path
    @container_path = [@enterprise]
  end

  def authorize_action(action, object)
    authorize :enterprise_folder, action.to_sym
  end
end
