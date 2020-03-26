class DiverstController < ApplicationController
  include Pundit
  include BaseController
  include BaseAuthentication
  include ActionController::Serialization

  serialization_scope :get_serialization_scope

  before_action :init_response
  before_action :verify_api_key
  before_action :verify_jwt_token

  # skip filter for routing errors
  skip_before_action :verify_jwt_token, only: [:routing_error]

  def error_json(e)
    if Rails.env.development? || Rails.end.test?
      { message: e.message, attribute: e&.attribute, backtrace: e.backtrace, cause: e.cause&.backtrace }
    else
      { message: e.message, attribute: e&.attribute }
    end
  end

  rescue_from UnprocessableException do |e|
    render status: :unprocessable_entity, json: [e.resource.errors.full_messages.first]
  end

  rescue_from InvalidInputException do |e|
    render status: :unprocessable_entity, json: error_json(e)
  end

  rescue_from Pundit::NotAuthorizedError do |e|
    render status: :unauthorized, json: error_json(e)
  end

  rescue_from ActionController::UnknownFormat do |e|
    render status: :forbidden, json: error_json(e)
  end

  rescue_from Pundit::AuthorizationNotPerformedError do |e|
    render status: :unauthorized, json: error_json(e)
  end

  rescue_from ActionController::BadRequest do |e|
    render status: :bad_request, json: error_json(e)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render status: :bad_request, json: error_json(e)
  end

  rescue_from BadRequestException do |e|
    render status: :bad_request, json: error_json(e)
  end

  rescue_from Pundit::NotDefinedError do |e|
    render status: :forbidden, json: error_json(e)
  end

  rescue_from ActionController::RoutingError do |e|
    render status: :forbidden, json: error_json(e)
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: :not_found, json: { message: 'Sorry, the resource you are looking for does not exist.' }
  end

  rescue_from ActiveRecord::StatementInvalid do |e|
    Rollbar.error(e)
    render status: :bad_request, json: error_json(e)
  end

  rescue_from ActionController::ParameterMissing do |e|
    render status: :bad_request, json: error_json(e)
  end

  rescue_from ActionController::UnpermittedParameters do |e|
    render status: :bad_request, json: error_json(e)
  end

  rescue_from ArgumentError do |e|
    render status: :bad_request, json: error_json(e)
  end

  rescue_from NoMethodError do |e|
    render status: :bad_request, json: error_json(e)
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
end
