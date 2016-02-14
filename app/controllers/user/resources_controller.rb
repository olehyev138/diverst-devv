class User::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'user'

  protected

  def set_container
    @group = @container = current_user.enterprise
  end
end
