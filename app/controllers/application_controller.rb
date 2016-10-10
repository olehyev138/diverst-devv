class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit

  helper_method :events_to_json

  protect_from_forgery with: :exception

  include ApplicationHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

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
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."

    if !current_user
      redirect_to new_user_session_path
    else
      redirect_to(request.referrer || default_path)
    end
  end
end
