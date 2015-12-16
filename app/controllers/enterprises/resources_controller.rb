class Enterprises::ResourcesController < ApplicationController
  include IsResources

  before_action :authenticate_user!
  before_action :authenticate_admin!, except: [:index, :show]

  layout :resolve_layout

  protected

  def set_container
    @container = current_user.enterprise
  end

  def resolve_layout
    ap current_user
    return "global_settings" if current_user(:admin).is_a? Admin
    "employee"
  end
end
