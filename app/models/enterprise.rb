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
    has_many :folders, as: :container
    has_many :folder_shares, as: :container
    has_many :shared_folders, through: :folder_shares, source: 'folder'
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
    has_many :group_categories
    has_many :group_category_types

    has_one :custom_text

    accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :mobile_fields, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :yammer_field_mappings, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :theme, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :reward_actions, reject_if: :all_blank, allow_destroy: true

    before_create :create_elasticsearch_only_fields
    before_create :set_default_email_texts
    before_validation :smart_add_url_protocol

    validates :idp_sso_target_url, url: { allow_blank: true }
    validates :cdo_name, :name, presence: true
    validates :user_group_mailer_notification_text, presence: true
    validates :campaign_mailer_notification_text, presence: true
    validates :approve_budget_request_mailer_notification_text, presence: true
    validates :poll_mailer_notification_text, presence: true
    validates :budget_approved_mailer_notification_text, presence: true
    validates :budget_declined_mailer_notification_text, presence: true
    
    validate :interpolated_texts

    has_attached_file :cdo_picture, styles: { medium: '1000x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
    validates_attachment_content_type :cdo_picture, content_type: %r{\Aimage\/.*\Z}

    has_attached_file :banner
    validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

    has_attached_file :xml_sso_config
    validates_attachment_content_type :xml_sso_config, content_type: 'text/xml'

    has_attached_file :sponsor_media, s3_permissions: :private
    do_not_validate_attachment_file_type :sponsor_media

    has_attached_file :onboarding_sponsor_media, s3_permissions: :private
    do_not_validate_attachment_file_type :onboarding_sponsor_media


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
    
    def set_default_email_texts
        self.user_group_mailer_notification_text = "<p>Hello %{user_name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of. Select the link(s) below to access Diverst and review the item(s)</p>\r\n"
        self.campaign_mailer_notification_text = "<p>Hello %{user_name},</p>\r\n\r\n<p>You are invited to join other members in the following online collaborative conversation in Diverst: %{campaign_name}</p>\r\n\r\n<p>%{join_now} to provide feedback and offer your thoughts and suggestions.</p>\r\n"
        self.approve_budget_request_mailer_notification_text = "<p>Hello %{user_name},</p>\r\n\r\n<p>You have received a request to approve a budget for: %{budget_name}</p>\r\n\r\n<p>%{click_here} to provide a review of the budget request.</p>\r\n"
        self.poll_mailer_notification_text= "<p>Hello %{user_name},</p>\r\n\r\n<p>You are invited to participate in the following online in Diverst: %{survey_name}</p>\r\n\r\n<p>%{click_here} to provide feedback and offer your thoughts and suggestions.</p>\r\n"
        self.budget_approved_mailer_notification_text = "<p>Hello %{user_name},</p>\r\n\r\n<p>Your budget request for: %{budget_name}&nbsp;has been approved.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n"
        self.budget_declined_mailer_notification_text = "<p>Hello %{user_name},</p>\r\n\r\n<p>Your budget request for: %{budget_name}&nbsp;has been declined.</p>\r\n\r\n<p>%{click_here} to access your budget request.</p>\r\n"
    end

    def interpolated_texts
        if user_group_mailer_notification_text && !user_group_mailer_notification_text.include?("%{user_name}")
            errors.add(:user_group_mailer_notification_text, 'Must include %{user_name}')
        elsif campaign_mailer_notification_text && (!campaign_mailer_notification_text.include?("%{user_name}") || !campaign_mailer_notification_text.include?("%{campaign_name}") || !campaign_mailer_notification_text.include?("%{join_now}"))
            errors.add(:campaign_mailer_notification_text, 'Must include %{user_name}, %{campaign_name} and %{join_now}')
        elsif approve_budget_request_mailer_notification_text && (!approve_budget_request_mailer_notification_text.include?("%{user_name}") || !approve_budget_request_mailer_notification_text.include?("%{budget_name}") || !approve_budget_request_mailer_notification_text.include?("%{click_here}"))
            errors.add(:approve_budget_request_mailer_notification_text, 'Must include %{user_name}, %{budget_name} and %{click_here}')
        elsif poll_mailer_notification_text && (!poll_mailer_notification_text.include?("%{user_name}") || !poll_mailer_notification_text.include?("%{survey_name}") || !poll_mailer_notification_text.include?("%{click_here}"))
            errors.add(:poll_mailer_notification_text, 'Must include %{user_name}, %{survey_name} and %{click_here}')
        elsif budget_approved_mailer_notification_text && (!budget_approved_mailer_notification_text.include?("%{user_name}") || !budget_approved_mailer_notification_text.include?("%{budget_name}") || !budget_approved_mailer_notification_text.include?("%{click_here}"))
            errors.add(:budget_approved_mailer_notification_text, 'Must include %{user_name}, %{budget_name} and %{click_here}')
        elsif budget_declined_mailer_notification_text && (!budget_declined_mailer_notification_text.include?("%{user_name}") || !budget_declined_mailer_notification_text.include?("%{budget_name}") || !budget_declined_mailer_notification_text.include?("%{click_here}"))
            errors.add(:budget_declined_mailer_notification_text, 'Must include %{user_name}, %{budget_name} and %{click_here}')
        end
    end

    protected 

    def smart_add_url_protocol
        return nil if company_video_url.blank?
        self.company_video_url = "http://#{company_video_url}" unless have_protocol?
    end

    def have_protocol?
        company_video_url[%r{\Ahttp:\/\/}] || company_video_url[%r{\Ahttps:\/\/}]
    end

    private

    def create_elasticsearch_only_fields
        fields << GroupsField.create
        fields << SegmentsField.create
    end
end
