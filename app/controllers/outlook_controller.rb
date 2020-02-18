class OutlookController < ApplicationController
  include OutlookAuthHelper
  layout 'outlook'

  def index
    @login_url = get_login_url
  end
end
