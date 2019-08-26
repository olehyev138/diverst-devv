class ApplicationController < ActionController::Base
  include Pundit
  include PublicActivity::StoreController
  include ApplicationHelper

  before_action :set_persist_login_param
  before_action :set_previous_url, unless: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError do |e|
    Rollbar.error(e)
    user_not_authorized
  end

  rescue_from ActionController::UnknownFormat do |e|
    Rails.logger.warn('UnknownFormat: ' + e.message)
    Rollbar.error(e)
    render status: 400, json: { error: e.message }
  end

  rescue_from ActionView::MissingTemplate do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rails.logger.warn('MissingTemplate: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActionView::Template::Error do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from Pundit::AuthorizationNotPerformedError do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rails.logger.warn('Template::Error: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActionController::BadRequest do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rails.logger.warn('BadRequest: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rails.logger.warn('RecordInvalid: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from BadRequestException do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rails.logger.warn('BadRequestException: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from Pundit::NotDefinedError do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActionController::RoutingError do |e|
    flash[:alert] = e.message
    Rails.logger.warn('RoutingError: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    flash[:alert] = 'Sorry, the resource you are looking for does not exist.' if Rails.env.production?
    flash[:alert] = e.message if Rails.env.development? || Rails.env.test?
    Rails.logger.warn('RecordNotFound: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActiveRecord::StatementInvalid do |e|
    flash[:alert] = e.message
    Rails.logger.warn('StatementInvalid: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActionController::ParameterMissing do |e|
    flash[:alert] = e.message
    Rails.logger.warn('ParameterMissing: ' + e.message)
    Rollbar.error(e)
    redirect_on_error
  end

  rescue_from ActionController::InvalidAuthenticityToken do |e|
    flash[:alert] = e.message
    Rollbar.warn(e)
    redirect_on_error
  end

  rescue_from NoMethodError do |e|
    flash[:alert] = e.message
    Rollbar.warn(e)
    redirect_on_error
  end

  around_action :user_time_zone, if: :current_user

  def temp
    Enterprise.first.users.each do |usr|
      r1 = rand(1..10)
      r2 = rand(1..10)
      GroupMessage.all.sample(r1).each do |gm|
        usr.message_comments << gm.comments.new(content: Faker::Lorem.sentence)
      end
      NewsLink.all.sample(r2).each do |nl|
        usr.news_link_comments << nl.comments.new(content: Faker::Lorem.sentence)
      end
    end
    nil
  end

  def redirect_on_error
    if user_signed_in?
      redirect_to(request.referrer || default_path)
      nil
    else
      unauth_user_redirect_destination
      nil
    end
  end

  def c_t(type)
    @custom_text ||= current_user.enterprise.custom_text rescue CustomText.new
    @custom_text.send("#{type}_text")
  end

  def routing_error
    if user_signed_in?
      flash[:alert] = 'Invalid Route'
      redirect_to(request.referrer || default_path)
    else
      render status: :forbidden, json: { message: 'Invalid Route' }
    end
  end

  def visit_page(name)
    return unless request.format == 'html'
    return if Rails.env.test?

    user_id = current_user.id
    controller = controller_path
    action = action_name
    origin = URI(request.referer || '').path
    page = URI(request.original_url).path

    return if page == origin

    IncrementViewCountJob.perform_later(user_id, page, name, controller, action)
  end

  protected

  def set_persist_login_param
    if params[:saml_for_enterprise].present?
      session[:saml_for_enterprise] = params[:saml_for_enterprise]
    end
  end

  def set_previous_url
    session[:previous_url] = request.url
  end

  def track_activity(model, activity_name, params = {})
    ActivityJob.perform_later(model.class.name, model.id, activity_name.to_s, current_user.id, params)
  end

  def not_found!
    fail ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    prev_url = session[:previous_url]

    # This ensures unauthorized users are not accessing main page, which is admin only
    # This also ensures we don't get stuck with invitation as our previous url. Otherwise it redirects to non-existent page
    if !current_user.seen_onboarding
      onboarding_index_path
    elsif prev_url && (prev_url != root_url) && (!prev_url.include? 'invitation')
      prev_url
    else
      user_root_path
    end
  end

  def after_sign_out_path_for(resource)
    if ENV['SSO_LOGIN_DEFAULT_ENTERPRISE_ID']
      enterprise = Enterprise.find_by_id(ENV['SSO_LOGIN_DEFAULT_ENTERPRISE_ID'])
      if enterprise.present? && enterprise.has_enabled_saml
        return logout_enterprise_saml_index_path(enterprise, slo: '1')
      end
    end
    new_user_session_path
  end

  def cors_allow_all
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  def allow_iframe
    response.headers.delete 'X-Frame-Options'
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.default_time_zone, &block)
  end

  def calculate_aggregate_data(sample)
    Rails.cache.fetch("calculate_aggregate_data/#{sample}") do
      max = sample.max_by { |x| x[1] }
      n = sample.count
      sum = sample.sum { |x| x[1] }
      mean = sum.to_f / n
      sd = Math.sqrt(sample.reduce(0) { |partial, element| partial + (element[1] - mean)**2 / n })
      return sum, max[0], max[1], mean.round(2), sd.round(2)
    end
  end

  def calculate_percentile(number, sample)
    Rails.cache.fetch("calculate_percentile/#{number}, #{sample}") do
      n = sample.count
      i = sample.each_index.select { |r| sample[r] <= number }.last
      101 - (100 * (i - 0.5) / n).round
    end
  end

  def aggregate_data_from_field(model, *fields, where: [nil])
    list_of_values = model.cached_count_list(*fields, where: where)
    calculate_aggregate_data(list_of_values)
  end

  def percentile_from_field(model, number, *fields, where: [nil])
    list_of_values = model.cached_count_list(*fields, where: where)
    calculate_percentile(number, list_of_values.map { |count| count[1] }.sort)
  end

  private

  def authenticate_user!(opts = {})
    if user_signed_in?
      super
    else
      redirect_to unauth_user_redirect_destination
    end
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    if !current_user
      session[:previous_url] = request.original_url
      redirect_to unauth_user_redirect_destination
    else
      redirect_to(request.referrer || default_path)
    end
  end

  def unauth_user_redirect_destination
    if ENV['SSO_LOGIN_DEFAULT_ENTERPRISE_ID']
      session[:previous_url] = request.original_url

      enterprise = Enterprise.find_by_id ENV['SSO_LOGIN_DEFAULT_ENTERPRISE_ID']

      if enterprise.present? && enterprise.has_enabled_saml?
        return sso_enterprise_saml_index_path(enterprise, 'RelayState' => session[:previous_url])
      end
    end

    new_user_session_path
  end
end
