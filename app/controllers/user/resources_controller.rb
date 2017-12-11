class User::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'user'

  protected

  def set_container
    if current_user
      @group = @container = current_user.enterprise
    else
      redirect_to new_user_session_path
    end
  end

  def set_container_path
    @container_path = [@container]
  end
end
