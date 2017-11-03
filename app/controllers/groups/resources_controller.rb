class Groups::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!
  before_filter :prepend_view_paths, :only => [:index]
  
  layout 'erg'
  
  def index
    if policy(@group).erg_leader_permissions? or @group.active_members.include? current_user
      @group_resources = @container.resources
      @national_resources = @container.enterprise.resources.where(:resource_type => "national")
      render '/index'
    else
        @group_resources = []
        @national_resources = @container.enterprise.resources.where(:resource_type => "national")
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
  
  def prepend_view_paths
    prepend_view_path 'app/views/groups/resources'
  end
end
