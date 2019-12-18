# Enterprise serializer for when the user is authenticated
class AuthenticatedEnterpriseSerializer < ApplicationRecordSerializer
  attributes :id, :name, :sp_entity_id, :idp_entity_id, :idp_sso_target_url, :idp_slo_target_url,
             :idp_cert, :saml_first_name_mapping, :saml_last_name_mapping, :has_enabled_saml, :created_at,
             :updated_at, :yammer_token, :yammer_import, :yammer_group_sync, :theme_id, :cdo_message,
             :collaborate_module_enabled, :scope_module_enabled, :plan_module_enabled, :home_message,
             :privacy_statement, :has_enabled_onboarding_email, :iframe_calendar_token, :time_zone,
             :enable_rewards, :company_video_url, :mentorship_module_enabled, :disable_likes,
             :default_from_email_address, :default_from_email_display_name, :enable_social_media,
             :redirect_all_emails, :disable_emails, :expiry_age_for_resources, :unit_of_expiry_age,
             :auto_archive, :theme, :enable_pending_comments, :redirect_email_contact

  has_one :custom_text
  has_many :mentoring_interests
  has_many :mentoring_types

  def theme
    return nil if object.theme.nil?

    ThemeSerializer.new(object.theme).attributes
  end
end