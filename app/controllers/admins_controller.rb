class AdminsController < ApplicationController
  before_action :authenticate_admin!
  #before_action :set_admin, only: [:edit, :update, :destroy, :show]

  layout "global_settings"
end
