class Api::V1::ApiController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :verify_authentication

  rescue_from Pundit::NotAuthorizedError do |e|
    error e.message
  end

  rescue_from ActionController::ParameterMissing do |e|
    error e.message
  end

  rescue_from ActionController::RoutingError do |e|
    error e.message
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error e.message
  end

  rescue_from ActionController::UrlGenerationError do |e|
    error e.message
  end

  rescue_from BadRequestException do |e|
    error e.message
  end

  # check if the request has permission to access
  # the API

  # status messages
  # 200 - ok
  # 201 - Resource Created
  # 204 - No Content
  # 400 - Bad Request - ex. render :json => :bad_request
  # 401 - Unauthorized
  # 404 - Not Found
  # 422 - Unprocessable Entity
  # 500 - Internal Server Error

  # users will authenticate with basic authentication
  # username
  # password

  attr_accessor :current_user

  def verify_authentication
    # verify headers/authorization is present?
    if request.authorization.present?
      # get the auth string and then the username and password
      string = request.authorization
      return process_headers(string)
    elsif request.headers['HTTP_AUTHORIZATION'].present?
      # get the auth string and then the username and password
      string = request.headers['HTTP_AUTHORIZATION']
      return process_headers(string)
    elsif params['headers'].present? && params['headers'].present?
      # get the auth string and then the username and password
      string = params['headers']['HTTP_AUTHORIZATION']
      return process_headers(string)
    end
    error
  end

  def process_headers(string)
    array = string.split(' ')

    credentials = Base64.decode64(array.second).split(':')

    authentication(credentials.first, credentials.second)
  end

  # pass email and password so we can check if the user
  # exists in our system

  def authentication(email, password)
    return error if email.nil?
    return error if password.nil?

    # want to downcase in case email is sent with a character capitalized
    user = User.find_by_email(email.downcase)
    return error 'Not Found', 401 if user.nil?

    return error 'Unauthorized', 401 if not user.valid_password?(password)

    # set the user
    self.current_user = user
  end

  def error(e = nil, status = nil)
    render status: status.presence || 400, json: { message: e.presence || bad_request }
  end

  def bad_request
    :bad_request
  end
end
