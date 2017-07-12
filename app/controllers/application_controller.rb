class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController
  include ApplicationHelper

  before_action :set_persist_login_param

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :events_to_json

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  around_action :user_time_zone, if: :current_user

  def c_t(type)
    @custom_text ||= current_user.enterprise.custom_text rescue CustomText.new
    @custom_text.send("#{ type }_text")
  end

  protected

  def set_persist_login_param
    if params[:saml_for_enterprise].present?
      session[:saml_for_enterprise] = params[:saml_for_enterprise]
    end
  end

  def track_activity(model, activity_name, params={})
    model.create_activity activity_name,
                owner: current_user,
                recipient: current_user.enterprise,
                params: params
  end

  def not_found!
    fail ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    return user_root_path
  end

  def after_sign_out_path_for(resource)
    return new_user_session_path
  end

  def cors_allow_all
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def allow_iframe
    response.headers.delete "X-Frame-Options"
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.default_time_zone, &block)
  end

  private

  def authenticate_user!(opts={})
    if user_signed_in?
      super
    else
      redirect_to unauth_user_redirect_destination
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."

    if !current_user
      redirect_to unauth_user_redirect_destination
    else
      redirect_to(request.referrer || default_path)
    end
  end

  def unauth_user_redirect_destination
    if ENV['SSO_LOGIN_DEFAULT_ENTERPRISE_ID']
      enterprise = Enterprise.find_by_id ENV['SSO_LOGIN_DEFAULT_ENTERPRISE_ID']

      if enterprise.present? && enterprise.has_enabled_saml?
        return sso_enterprise_saml_index_path(enterprise)
      end
    end

    new_user_session_path
  end
end
