class Enterprises::ResourcesController < ApplicationController
  include IsResources

  layout :resolve_layout

  def new
    authorize Resource
  end

  protected

  def set_container
    @container = current_user.enterprise
  end

  def resolve_layout
    # return 'erg_manager' if current_user(:admin).is_a? Admin TODO
    'user'
  end
end
