class Enterprise < ActiveRecord::Base
  has_many :admins
  has_many :employees
  has_many :fields

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    settings.assertion_consumer_service_url = "http://#{ENV['DOMAIN']}/enterprises/#{self.id}/saml/acs"

    settings.idp_entity_id = self.idp_entity_id
    settings.idp_sso_target_url = self.idp_sso_target_url
    settings.idp_slo_target_url = self.idp_slo_target_url
    settings.idp_cert = self.idp_cert
    settings.name_identifier_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = false
    settings.security[:digest_method] = XMLSecurity::Document::SHA1
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

    settings
  end
end
