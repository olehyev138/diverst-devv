class Groups::ResourcesController < ApplicationController
  include IsResources

  layout 'erg'

  protected

  def set_container
    @group = @container = current_user.enterprise.groups.find(params[:group_id])
  end
end
