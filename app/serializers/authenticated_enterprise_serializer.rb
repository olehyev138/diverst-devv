# Enterprise serializer for when the user is authenticated
class AuthenticatedEnterpriseSerializer < ApplicationRecordSerializer
  attributes :id, :name, :sp_entity_id, :idp_entity_id, :idp_sso_target_url, :idp_slo_target_url,
             :idp_cert, :saml_first_name_mapping, :saml_last_name_mapping, :has_enabled_saml, :created_at,
             :updated_at, :yammer_token, :yammer_import, :yammer_group_sync, :theme_id, :cdo_picture_file_name,
             :cdo_picture_content_type, :cdo_picture_file_size, :cdo_picture_updated_at, :cdo_message,
             :collaborate_module_enabled, :scope_module_enabled, :plan_module_enabled, :banner_file_name,
             :banner_content_type, :banner_file_size, :banner_updated_at, :home_message, :privacy_statement,
             :has_enabled_onboarding_email, :xml_sso_config_file_name, :xml_sso_config_content_type,
             :xml_sso_config_file_size, :xml_sso_config_updated_at, :iframe_calendar_token, :time_zone,
             :enable_rewards, :company_video_url, :onboarding_sponsor_media_file_name,
             :onboarding_sponsor_media_content_type, :onboarding_sponsor_media_file_size,
             :onboarding_sponsor_media_updated_at, :enable_pending_comments, :mentorship_module_enabled,
             :disable_likes, :default_from_email_address, :default_from_email_display_name,
             :enable_social_media, :redirect_all_emails, :redirect_email_contact, :disable_emails,
             :expiry_age_for_resources, :unit_of_expiry_age, :auto_archive, :theme

  has_one :custom_text

  def theme
    return nil if object.theme.nil?

    ThemeSerializer.new(object.theme).attributes
  end
end
