class DiverstController < ApplicationController
  include Pundit
  include BaseController
  include BaseAuthentication
  include ActionController::Serialization
  include ApiHelper

  around_action :apply_locale

  serialization_scope :get_serialization_scope

  before_action :init_response
  before_action :verify_api_key
  before_action :verify_jwt_token

  # skip filter for routing errors
  skip_before_action :verify_jwt_token, only: [:routing_error]

  # Locale is pulled from the 'Diverst-Locale' header (this is how it works with our frontend), but the locale can also be passed via params
  # Silently falls back to default locale if the passed locale is not valid
  def apply_locale(&action)
    locale = (params[:locale] || request.headers['Diverst-Locale'] || I18n.default_locale).to_s.downcase
    I18n.with_locale(is_supported_locale?(locale) ? locale : I18n.default_locale, &action)
  end

  # Checks if the passed locale string is a valid locale & is an available locale, returns true if so, false otherwise
  def is_supported_locale?(locale)
    I18n.available_locales.map(&:to_s).include?(locale)
  rescue
    false
  end

  def error_json(e)
    json = { message: e.message }
    json[:attribute] = e.attribute if e.respond_to?(:attribute)
    json[:errors] = e.errors if e.respond_to?(:errors)
    if Rails.env.development? || Rails.env.test?
      json[:backtrace] = e.backtrace
      json[:cause] = e.cause&.backtrace
    end

    json
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
    apply_locale do
      render status: :not_found, json: { message: t('errors.not_found', count: 1) }
    end
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
    apply_locale do
      render status: :request_timeout, json: { message: t('errors.timed_out') }
    end
  end

  rescue_from Rack::Timeout::RequestExpiryError do |e|
    apply_locale do
      render status: :request_timeout, json: { message: t('errors.timed_out') }
    end
  end

  rescue_from Rack::Timeout::RequestTimeoutError do |e|
    apply_locale do
      render status: :request_timeout, json: { message: t('errors.timed_out') }
    end
  end

  def routing_error
    apply_locale do
      render status: :forbidden, json: { message: t('errors.invalid_route') }
    end
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
