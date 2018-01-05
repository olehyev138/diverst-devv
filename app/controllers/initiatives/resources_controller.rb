class Initiatives::ResourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  include IsResources


  layout 'plan'

  protected
  def set_group
    @group = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_container
    @initiative = @container = current_user.enterprise.initiatives.find(params[:initiative_id])
  end

  def set_container_path
    @container_path = [@group, @initiative]
  end
end
