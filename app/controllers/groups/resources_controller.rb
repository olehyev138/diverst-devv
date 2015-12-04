class Groups::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!
  before_action :authenticate_admin!, except: [:index, :show]

  layout "erg"

  protected

  def set_container
    @group = @container = current_user.enterprise.groups.find(params[:group_id])
  end
end
