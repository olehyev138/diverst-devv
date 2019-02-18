class Groups::FoldersController < ApplicationController
  include Folders

  before_action :authenticate_user!

  layout 'erg'

  def index
    if policy(@group).manage? || policy(@group).is_an_accepted_member?
      super
    else
      @folders = []
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
