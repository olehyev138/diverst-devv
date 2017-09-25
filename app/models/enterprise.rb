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

    has_many :rewards
    has_many :reward_actions
    has_many :badges

    has_one :custom_text

    accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :mobile_fields, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :yammer_field_mappings, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :theme, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :reward_actions, reject_if: :all_blank, allow_destroy: true

    before_create :create_elasticsearch_only_fields

    validates :idp_sso_target_url, url: { allow_blank: true }

    has_attached_file :cdo_picture, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: "private"
    validates_attachment_content_type :cdo_picture, content_type: %r{\Aimage\/.*\Z}

    has_attached_file :banner
    validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

    has_attached_file :xml_sso_config
    validates_attachment_content_type :xml_sso_config, content_type: 'text/xml'

    def custom_text
        super || create_custom_text
    end

    def default_time_zone
        return time_zone if time_zone.present?

        'UTC'
    end

    def iframe_calendar_token
        unless self[:iframe_calendar_token]
            self.update(iframe_calendar_token: SecureRandom.urlsafe_base64)
        end

        self[:iframe_calendar_token]
    end

    def saml_settings
        #if xml config file is present - take settings from it
        if xml_sso_config?
            idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
            file_content = Paperclip.io_adapters.for(xml_sso_config).read
            settings = idp_metadata_parser.parse(file_content)
        else #otherwise - initialize empty settings
            settings = OneLogin::RubySaml::Settings.new
            settings.name_identifier_format = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
        end

        settings.assertion_consumer_service_url = "https://#{ENV['DOMAIN']}/enterprises/#{id}/saml/acs"

        #override xml file settings with enterprise settings, if they are present
        settings.issuer = sp_entity_id                    if sp_entity_id.present?
        settings.idp_entity_id = idp_entity_id            if idp_entity_id.present?
        settings.idp_sso_target_url = idp_sso_target_url  if idp_sso_target_url.present?
        settings.idp_slo_target_url = idp_slo_target_url  if idp_slo_target_url.present?
        settings.idp_cert = idp_cert                      if idp_cert.present?

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

    def sso_fields_to_enterprise_fields(sso_attrs)
        mapped_fields = {}

        fields.each do |field|
            sso_attrs.each do |sso_f_key, sso_f_value|
                if sso_f_key == field.saml_attribute
                    if sso_f_value.instance_of? Array
                        string_value = sso_f_value.join(',')
                    else
                        string_value = sso_f_value
                    end

                    mapped_fields.merge!(field.id => string_value)
                    next
                end
            end
        end

        mapped_fields
    end

    private

    def create_elasticsearch_only_fields
        fields << GroupsField.create
        fields << SegmentsField.create
    end
end
