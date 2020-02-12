# Enterprise serializer for authenticated user (after login)
class AuthenticatedEnterpriseSerializer < ApplicationRecordSerializer
  attributes :id, :name, :has_enabled_saml, :created_at,
             :updated_at, :theme_id, :cdo_message, :home_message,
             :privacy_statement, :has_enabled_onboarding_email, :iframe_calendar_token, :enable_rewards,
             :company_video_url, :enable_pending_comments, :mentorship_module_enabled, :disable_likes,
             :default_from_email_address, :default_from_email_display_name, :enable_social_media,
             :redirect_all_emails, :redirect_email_contact, :disable_emails, :expiry_age_for_resources,
             :unit_of_expiry_age, :auto_archive, :timezones, :time_zone

  has_one :custom_text
  has_many :mentoring_interests
  has_many :mentoring_types

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
