class IntegrationsController < ApplicationController
  before_action :authenticate_admin!

  layout 'global_settings'
end
