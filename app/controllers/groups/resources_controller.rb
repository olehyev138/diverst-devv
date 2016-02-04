class Groups::ResourcesController < ApplicationController
  include IsResources
  include AccessControl

  before_action :authenticate_admin!

  layout 'erg'

  protected

  def set_container
    @group = @container = current_user.enterprise.groups.find(params[:group_id])
  end
end
