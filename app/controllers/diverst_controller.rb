class DiverstController < ApplicationController
  include Pundit
  include BaseController
  include ActionController::Serialization

  serialization_scope :get_serialization_scope

  # verification filters
  before_action :init_response
  before_action :verify_api_key
  before_action :verify_jwt_token

  # skip filter for routing errors
  skip_before_action :verify_jwt_token, only: [:routing_error]

  # accessors
  attr_accessor :current_user
  attr_accessor :diverst_request

  rescue_from UnprocessableException do |e|
    render status: :unprocessable_entity, json: [e.resource.errors.full_messages.first]
  end

  rescue_from InvalidInputException do |e|
    render status: :unprocessable_entity, json: { message: e.message, attribute: e.attribute }
  end

  rescue_from Pundit::NotAuthorizedError do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from ActionController::UnknownFormat do |e|
    render status: :forbidden, json: { message: e.message }
  end

  rescue_from Pundit::AuthorizationNotPerformedError do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from ActionController::BadRequest do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from BadRequestException do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from Pundit::NotDefinedError do |e|
    render status: :forbidden, json: { message: e.message }
  end

  rescue_from ActionController::RoutingError do |e|
    render status: :forbidden, json: { message: e.message }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: :not_found, json: { message: 'Sorry, the resource you are looking for does not exist.' }
  end

  rescue_from ActiveRecord::StatementInvalid do |e|
    Rollbar.error(e)
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from ActionController::ParameterMissing do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from ActionController::UnpermittedParameters do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from ArgumentError do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from NoMethodError do |e|
    render status: :bad_request, json: { message: e.message }
  end

  rescue_from Rack::Timeout::RequestTimeoutException do |e|
    render status: :request_timeout, json: { message: 'Your request timed out. Please try again later.' }
  end

  rescue_from Rack::Timeout::RequestExpiryError do |e|
    render status: :request_timeout, json: { message: 'Your request timed out. Please try again later.' }
  end

  rescue_from Rack::Timeout::RequestTimeoutError do |e|
    render status: :request_timeout, json: { message: 'Your request timed out. Please try again later.' }
  end

  def routing_error
    render status: :forbidden, json: { message: 'Invalid route' }
  end

  # for active model serializers
  def default_serializer_options
    { root: false }
  end

  def get_serialization_scope
    if self.current_user.nil?
      return {
               image_size: params[:image_size],
               controller: self.diverst_request.controller,
               action: self.diverst_request.action
             }
    end

    {
      image_size: params[:image_size],
      current_user: self.diverst_request.user,
      policy_group: self.diverst_request.policy_group,
      controller: self.diverst_request.controller,
      action: self.diverst_request.action
    }
  end

  # verify the JWT token, load the user and abilities
  def verify_jwt_token
    token = request.headers['Diverst-UserToken']

    if not token
      token = params['Diverst-UserToken']
    end

    if not token
      render status: 401, json: { message: 'Invalid User Token' }
      return
    end

    begin
      # get the user from the token
      self.current_user = UserTokenService.verify_jwt_token token
      # add the remaining data to the response
      self.diverst_request.user = current_user
      self.diverst_request.policy_group = current_user.policy_group
    rescue => e
      render status: :unauthorized, json: { message: e.message }
    end
  end

  # verify there is an api key in the request
  def verify_api_key
    api_key = request.headers['Diverst-APIKey']

    if api_key.nil?
      api_key = params[:api_key]
      if api_key.nil?
        render status: 403, json: { message: 'Invalid API Key' }
        return
      end
    end

    api_key_object = ApiKey.find_by_key(api_key)

    if api_key_object.nil?
      render status: 403, json: { message: 'Invalid API Key' }
      return
    end
  end

  def init_response
    self.diverst_request = Request.new
    self.diverst_request.controller = controller_name
    self.diverst_request.action = action_name
  end
end
