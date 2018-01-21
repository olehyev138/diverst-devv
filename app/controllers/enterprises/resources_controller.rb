class Enterprises::ResourcesController < ApplicationController
  include IsResources

  before_action :set_resource_type, only: [:new]
  before_action :authenticate_user!
  before_filter :prepend_view_paths, :only => [:index]

  layout 'erg_manager'

  def index
    @admin_resources = @container.resources.where(:resource_type => "admin")
    @national_resources = @container.resources.where(:resource_type => "national")
    render '/index'
  end

  def new
    @resource = @container.resources.new(:resource_type => @resource_type)
    render '/new'
  end

  protected

  def set_container
    current_user ? @container = current_user.enterprise : user_not_authorized
  end

  def set_container_path
    @container_path = [@container]
  end

  def set_resource_type
    @resource_type = params[:resource_type]
  end

  def prepend_view_paths
    prepend_view_path 'app/views/enterprises/resources'
  end
end
