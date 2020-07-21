# Enterprise serializer for authenticated user (after login)
class AuthenticatedEnterpriseSerializer < ApplicationRecordSerializer
  attributes :id, :name, :sp_entity_id, :idp_entity_id, :idp_sso_target_url, :idp_slo_target_url,
             :idp_cert, :saml_first_name_mapping, :saml_last_name_mapping, :has_enabled_saml, :created_at,
             :updated_at, :yammer_token, :yammer_import, :yammer_group_sync, :theme_id, :cdo_message,
             :collaborate_module_enabled, :scope_module_enabled, :plan_module_enabled, :home_message,
             :privacy_statement, :has_enabled_onboarding_email, :iframe_calendar_token, :enable_rewards,
             :company_video_url, :enable_pending_comments, :mentorship_module_enabled, :enable_likes,
             :default_from_email_address, :default_from_email_display_name, :enable_social_media,
             :redirect_all_emails, :redirect_email_contact, :disable_emails, :expiry_age_for_resources,
             :unit_of_expiry_age, :auto_archive, :theme, :timezones, :time_zone,
             :banner, :banner_file_name, :banner_data, :banner_content_type, :onboarding_consent_enabled, :onboarding_consent_message

  has_one :custom_text
  has_many :mentoring_interests
  has_many :mentoring_types

  def banner
    AttachmentHelper.attachment_signed_id(object.banner)
  end

  def banner_file_name
    AttachmentHelper.attachment_file_name(object.banner)
  end

  def banner_data
    AttachmentHelper.attachment_data_string(object.banner)
  end

  def banner_content_type
    AttachmentHelper.attachment_content_type(object.banner)
  end

  def theme
    return nil if object.theme.nil?

    ThemeSerializer.new(object.theme).attributes
  end

  def timezones
    TimeZoneHelpers.timezones
  end

  def time_zone
    TimeZoneHelpers.time_zone(object)
  end
end
