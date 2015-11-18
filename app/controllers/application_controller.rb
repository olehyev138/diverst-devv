class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  protected

  def authenticate_inviter!
    authenticate_admin!(:force => true)
  end

  def current_user
    current_admin || current_employee
  end

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    return employees_campaigns_path if resource.is_a? Employee
    return metrics_dashboards_path if resource.is_a? Admin
  end
end
