class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  devise_group :user, contains: [:employee, :admin]

  protected

  def authenticate_inviter!
    authenticate_admin!(force: true)
  end

  def not_found!
    fail ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    return employee_campaigns_path if resource.is_a? Employee
    return metrics_dashboards_path if resource.is_a? Admin
  end

  def after_sign_out_path_for(resource)
    return new_employee_session_path if resource == :employee
    return new_admin_session_path if resource == :admin
  end

  def cors_allow_all
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
