class Enterprises::ResourcesController < ApplicationController
  include IsResources

  before_action :set_resource_type, only: [:new]
  before_filter :prepend_view_paths, only: [:index]

  layout 'erg_manager'

  def index
    @admin_resources = @container.resources.where(resource_type: 'admin')
    @national_resources = @container.resources.where(resource_type: 'national')
    render '/index'
  end

  def new
    @resource = @container.resources.new(resource_type: @resource_type)
    render '/new'
  end

  def archived
    super
  end

  def restore_all
    super
  end

  def delete_all
    super
  end

  protected

  def set_container
    @container = current_user.enterprise
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
