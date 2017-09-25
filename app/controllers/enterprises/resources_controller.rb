class Enterprises::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'erg_manager'

  protected

  def set_container
    @container = current_user.enterprise
  end

  def set_container_path
    @container_path = [@container]
  end
end
