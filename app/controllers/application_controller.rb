class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  layout "dashboard"

  protected

  def authenticate_inviter!
    authenticate_admin!(:force => true)
  end

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end
end
