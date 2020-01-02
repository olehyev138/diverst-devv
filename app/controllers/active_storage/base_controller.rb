# frozen_string_literal: true

# The base class for all Active Storage controllers.
class ActiveStorage::BaseController < ActionController::Base
  include BaseAuthentication

  before_action :init_response
  before_action :verify_api_key
  before_action :verify_jwt_token

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action do
    ActiveStorage::Current.host = request.base_url
  end
end