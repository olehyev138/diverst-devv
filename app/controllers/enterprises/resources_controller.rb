class Enterprises::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!
  before_action :authenticate_admin!, except: [:index, :show]

  layout "global_settings"

  protected

  def set_container
    @container = current_user.enterprise
  end
end
