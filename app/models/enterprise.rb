class Enterprise < ActiveRecord::Base
  has_many :admins, inverse_of: :enterprise
  has_many :employees, inverse_of: :enterprise
  has_many :fields, inverse_of: :enterprise
  has_many :topics, inverse_of: :enterprise
  has_many :segments, inverse_of: :enterprise
  has_many :groups, inverse_of: :enterprise
  has_many :polls, inverse_of: :enterprise
  has_many :mobile_fields, inverse_of: :enterprise
  has_many :metrics_dashboards, inverse_of: :enterprise
  has_many :campaigns
  has_many :questions, through: :campaigns
  has_many :answers, through: :questions
  has_many :answer_comments, through: :answers

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :mobile_fields, reject_if: :all_blank, allow_destroy: true

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

  def match_fields(include_disabled: false)
    matchable_field_types = ["NumericField", "SelectField", "CheckboxField"]
    fields = self.fields.where(type: matchable_field_types)
    fields.where(match_exclude: false) unless include_disabled
  end

  def update_matches
    GenerateEnterpriseMatchesJob.perform_later self
  end
end
