class Enterprises::ResourcesController < ApplicationController
  include IsResources

  layout 'erg_manager'

  protected

  def set_container
    @container = current_user.enterprise
  end
end
