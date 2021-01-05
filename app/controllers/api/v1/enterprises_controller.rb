class Api::V1::EnterprisesController < DiverstController
  skip_before_action :verify_api_key, only: [:sso_login, :sso_link]
  skip_before_action :verify_jwt_token, only: [:sso_login, :sso_link, :get_auth_enterprise]
  include Api::V1::Concerns::DefinesFields

  def sso_login
    redirect_to klass.sso_login(self.diverst_request, params)
  rescue => e
    redirect_to "#{ENV['DOMAIN']}/login?errorMessage=#{e.message}"
  end

  def sso_link
    render status: 200, json: klass.sso_link(self.diverst_request, params)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_auth_enterprise
    preloaded_enterprise = Enterprise.preload(
        :theme,
        :sponsors,
        theme: [:logo_attachment, :logo_blob],
        sponsors: [:sponsor_media_attachment, :sponsor_media_blob]
      )
    if params[:enterprise_id].blank?
      enterprise = preloaded_enterprise.first
    else
      enterprise = preloaded_enterprise.find(params[:enterprise_id])
    end

    render json: enterprise
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def get_enterprise
    enterprise = self.diverst_request.user.enterprise
    base_authorize(enterprise)

    render status: 200, json: enterprise, serializer: AuthenticatedEnterpriseSerializer
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def update_enterprise
    params[klass.symbol] = payload

    enterprise = Enterprise.find(diverst_request.user.enterprise.id)
    base_authorize(enterprise)

    if params.dig(:enterprise, :theme_attributes) && params.dig(:enterprise, :theme_attributes, :logo).blank? && enterprise.theme&.logo&.attached?
      enterprise.theme.logo.purge_later
      params[:enterprise][:theme_attributes] = params[:enterprise][:theme_attributes].except(:logo)
    end

    [:banner, :cdo_picture, :xml_sso_config, :sponsor_media, :onboarding_sponsor_media].each do |attachment|
      if params[:enterprise][attachment].blank? && enterprise.send(attachment).attached?
        enterprise.send(attachment).purge_later
        params[:enterprise] = params[:enterprise].except(attachment)
      end
    end

    enterprise.update(params[:enterprise])
    track_activity(enterprise)

    render status: 200, json: enterprise, serializer: AuthenticatedEnterpriseSerializer
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end

  def update_sso
    params[klass.symbol] = sso_payload
    params[:id] = diverst_request.user.enterprise.id
    item = Enterprise.find(diverst_request.user.enterprise.id)
    base_authorize(item)

    updated_item = klass.update(self.diverst_request, params)
    track_activity(updated_item)
    render status: 200, json: updated_item, serializer: AuthenticatedEnterpriseSerializer
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def update_branding
    params[klass.symbol] = branding_payload
    params[:id] = diverst_request.user.enterprise.id
    item = Enterprise.find(diverst_request.user.enterprise.id)
    base_authorize(item)

    item.banner.purge_later if params[:enterprise].key?(:banner) && params[:enterprise][:banner].blank? && item.banner.attached?

    if item.theme.present? &&
        params[:enterprise].key?(:theme_attributes) &&
        params[:enterprise][:theme_attributes].key?(:logo) &&
        params[:enterprise][:theme_attributes][:logo].blank? &&
        item.theme.logo.attached?
      item.theme.logo.purge_later
    end

    updated_item = klass.update(self.diverst_request, params)
    track_activity(updated_item)
    render status: 200, json: updated_item, serializer: AuthenticatedEnterpriseSerializer
  rescue => e
    case e
    when InvalidInputException, Pundit::NotAuthorizedError then raise
    else raise BadRequestException.new(e.message)
    end
  end

  def sso_payload
    params
        .require(klass.symbol)
        .permit(
            :sp_entity_id,
            :idp_entity_id,
            :idp_sso_target_url,
            :idp_slo_target_url,
            :idp_cert,
            :saml_first_name_mapping,
            :saml_last_name_mapping,
            :has_enabled_saml,
          )
  end

  def branding_payload
    params
        .require(klass.symbol)
        .permit(
            :banner,
            :home_message,
            :onboarding_consent_enabled,
            :onboarding_consent_message,
            :privacy_statement,
            theme_attributes: [
                :logo,
                :logo_redirect_url,
                :primary_color,
                :secondary_color,
                :use_secondary_color,
            ]
          )
  end

  def payload
    params
    .require(klass.symbol)
    .permit(
      :name,
      :sp_entity_id,
      :idp_entity_id,
      :idp_sso_target_url,
      :idp_slo_target_url,
      :idp_cert,
      :saml_first_name_mapping,
      :saml_last_name_mapping,
      :has_enabled_saml,
      :created_at,
      :updated_at,
      :yammer_token,
      :yammer_import,
      :yammer_group_sync,
      :theme_id,
      :cdo_picture_file_name,
      :cdo_picture_content_type,
      :cdo_picture_file_size,
      :cdo_picture_updated_at,
      :cdo_message,
      :collaborate_module_enabled,
      :scope_module_enabled,
      :plan_module_enabled,
      :banner,
      :home_message,
      :privacy_statement,
      :has_enabled_onboarding_email,
      :xml_sso_config_file_name,
      :xml_sso_config_content_type,
      :xml_sso_config_file_size,
      :xml_sso_config_updated_at,
      :iframe_calendar_token,
      :time_zone,
      :enable_rewards,
      :company_video_url,
      :onboarding_sponsor_media_file_name,
      :onboarding_sponsor_media_content_type,
      :onboarding_sponsor_media_file_size,
      :onboarding_sponsor_media_updated_at,
      :enable_pending_comments,
      :mentorship_module_enabled,
      :enable_likes,
      :default_from_email_address,
      :default_from_email_display_name,
      :enable_social_media,
      :redirect_all_emails,
      :redirect_email_contact,
      :disable_emails,
      :expiry_age_for_resources,
      :unit_of_expiry_age,
      :auto_archive,
      :onboarding_consent_enabled,
      :onboarding_consent_message,
      theme_attributes: [
        :primary_color,
        :secondary_color,
        :use_secondary_color,
        :logo,
        :logo_redirect_url,
      ]
    )
  end

  private def action_map(action)
    case action
    when :update then if payload[:theme_attributes].present? || payload[:home_message].present?
                        'update_branding'
                      else
                        'update'
                      end
    else nil
    end
  end
end
