class User::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'user'

  protected

  def set_container
    @group = @container = current_user.enterprise
  rescue
    user_not_authorized
  end

  def set_container_path
    @container_path = [@container]
  end
end
