# Limited enterprise serializer for use before authentication
class EnterpriseSerializer < ApplicationRecordSerializer
  attributes :id, :name, :sp_entity_id, :idp_entity_id, :idp_sso_target_url, :idp_slo_target_url,
             :idp_cert, :saml_first_name_mapping, :saml_last_name_mapping, :has_enabled_saml,
             :time_zone, :default_from_email_address, :default_from_email_display_name,
             :redirect_email_contact, :mentorship_module_enabled, :enable_likes, :enable_pending_comments,
             :collaborate_module_enabled, :scope_module_enabled, :has_enabled_onboarding_email, :disable_emails,
             :enable_rewards, :enable_social_media, :plan_module_enabled, :timezones, :time_zone

  belongs_to :theme
  has_many :sponsors

  # Custom Attributes

  def timezones
    TimeZoneHelpers.timezones
  end

  def time_zone
    TimeZoneHelpers.time_zone(object)
  end
end
