class Groups::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!

  layout 'erg'
  
  def index
    if policy(@group).erg_leader_permissions? or @group.active_members.include? current_user
      super
    else
        @resources = []
        render '/index'
    end
  end

  protected

  def set_container
    @group = @container = current_user.enterprise.groups.find(params[:group_id])
  end

  def set_container_path
    @container_path = [@group]
  end
end
