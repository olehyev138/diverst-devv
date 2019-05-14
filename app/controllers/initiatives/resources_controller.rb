class Initiatives::ResourcesController < ApplicationController
  before_action :set_group, except: [:restore, :destroy]

  include IsResources

  layout 'erg'

  def destroy
    initiative_ids = current_user.enterprise.initiative_ids
    @resources = Resource.where("resources.initiative_id IN (#{initiative_ids.join(',')}) AND archived_at IS NULL").all

    track_activity(@resource, :destroy)
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

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
