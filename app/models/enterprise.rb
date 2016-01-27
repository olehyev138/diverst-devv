class Enterprise < ActiveRecord::Base
  include ContainsResources

  has_many :admins, inverse_of: :enterprise
  has_many :employees, inverse_of: :enterprise
  has_many :graph_fields, as: :container, class_name: 'Field'
  has_many :fields, -> { where elasticsearch_only: false }, as: :container
  has_many :topics, inverse_of: :enterprise
  has_many :segments, inverse_of: :enterprise
  has_many :groups, inverse_of: :enterprise
  has_many :events, through: :groups
  has_many :polls, inverse_of: :enterprise
  has_many :mobile_fields, inverse_of: :enterprise
  has_many :metrics_dashboards, inverse_of: :enterprise
  has_many :graphs, through: :metrics_dashboards
  has_many :poll_graphs, through: :polls, source: :graphs
  has_many :campaigns
  has_many :questions, through: :campaigns
  has_many :answers, through: :questions
  has_many :answer_comments, through: :answers, source: :comments
  has_many :answer_upvotes, through: :answers, source: :votes
  has_many :resources, as: :container
  has_many :yammer_field_mappings
  has_many :emails
  belongs_to :theme

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :mobile_fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :yammer_field_mappings, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :theme, reject_if: :all_blank, allow_destroy: true

  before_create :create_elasticsearch_only_fields

  validates :idp_sso_target_url, url: { allow_blank: true }

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    settings.assertion_consumer_service_url = "http://#{ENV['DOMAIN']}/enterprises/#{id}/saml/acs"

    settings.idp_entity_id = idp_entity_id
    settings.idp_sso_target_url = idp_sso_target_url
    settings.idp_slo_target_url = idp_slo_target_url
    settings.idp_cert = idp_cert
    settings.name_identifier_format = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = false
    settings.security[:logout_responses_signed] = false
    settings.security[:metadata_signed] = false
    settings.security[:digest_method] = XMLSecurity::Document::SHA1
    settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

    settings
  end

  def match_fields(include_disabled: false)
    matchable_field_types = %w(NumericField SelectField CheckboxField)
    fields = self.fields.where(type: matchable_field_types)
    fields.where(match_exclude: false) unless include_disabled
  end

  def update_matches
    GenerateEnterpriseMatchesJob.perform_later self
  end

  def update_match_scores
    enterprise.employees.where.not(id: id).each do |other_employee|
      CalculateMatchScoreJob.perform_later(self, other_employee, skip_existing: false)
    end
  end

  def employees_csv(nb_rows)
    Employee.to_csv(employees: employees, fields: fields, nb_rows: nb_rows)
  end

  # Returns the index name to be used in Elasticsearch to store this enterprise's employees
  def es_employees_index_name
    "#{id}_employees"
  end

  # Run an elasticsearch query on the enterprise's employees
  def search_employees(search_hash)
    Elasticsearch::Model.client.search(index: es_employees_index_name, body: search_hash)
  end

  private

  def create_elasticsearch_only_fields
    fields << GroupsField.create
    fields << SegmentsField.create
  end
end
