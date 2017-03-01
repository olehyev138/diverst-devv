class Enterprise < ActiveRecord::Base
  include ContainsResources

  has_many :users, inverse_of: :enterprise
  has_many :graph_fields, as: :container, class_name: 'Field'
  has_many :fields, -> { where elasticsearch_only: false }, as: :container
  has_many :topics, inverse_of: :enterprise
  has_many :segments, inverse_of: :enterprise
  has_many :groups, inverse_of: :enterprise
  has_many :events, through: :groups
  has_many :initiatives, through: :groups
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
  has_many :policy_groups
  has_many :expenses
  has_many :expense_categories
  has_many :biases, through: :users, class_name: "Bias"
  has_many :departments

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :mobile_fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :yammer_field_mappings, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :theme, reject_if: :all_blank, allow_destroy: true

  before_create :create_elasticsearch_only_fields

  validates :idp_sso_target_url, url: { allow_blank: true }

  has_attached_file :cdo_picture, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_attachment_content_type :cdo_picture, content_type: %r{\Aimage\/.*\Z}

  has_attached_file :banner
  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    settings.assertion_consumer_service_url = "http://#{ENV['DOMAIN']}/enterprises/#{id}/saml/acs"

    settings.issuer = sp_entity_id
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
    enterprise.users.where.not(id: id).each do |other_user|
      CalculateMatchScoreJob.perform_later(self, other_user, skip_existing: false)
    end
  end

  def users_csv(nb_rows)
    User.to_csv(users: users, fields: fields, nb_rows: nb_rows)
  end

  # Run an elasticsearch query on the enterprise's users
  def search_users(search_hash)
    Elasticsearch::Model.client.search(
      index: User.es_index_name(enterprise: self),
      body: search_hash,
      search_type: 'count'
    )
  end

  # Necessary to be implement a graph container
  def enterprise
    self
  end

  def default_policy_group
    PolicyGroup.default_group(self.id)
  end

  private

  def create_elasticsearch_only_fields
    fields << GroupsField.create
    fields << SegmentsField.create
  end
end
