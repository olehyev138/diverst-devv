class Enterprise < ApplicationRecord
  include ContainsResources
  include PublicActivity::Common
  include Enterprise::Actions
  include TimeZoneValidation
  include CustomTextHelpers

  extend Enumerize

  enumerize :unit_of_expiry_age, default: :months, in: [
    :weeks,
    :months,
    :years
  ]

  has_many :users, inverse_of: :enterprise, dependent: :destroy
  has_many :graph_fields, as: :field_definer, class_name: 'Field', dependent: :destroy
  has_many :fields, -> { where elasticsearch_only: false }, as: :field_definer, dependent: :destroy
  has_many :topics, inverse_of: :enterprise, dependent: :destroy
  has_many :segments, inverse_of: :enterprise, dependent: :destroy
  has_many :groups, inverse_of: :enterprise, dependent: :destroy
  has_many :initiatives, through: :groups
  has_many :folders, dependent: :destroy
  has_many :folder_shares, dependent: :destroy
  has_many :shared_folders, through: :folder_shares, source: 'folder'
  has_many :polls, inverse_of: :enterprise, dependent: :destroy
  has_many :mobile_fields, inverse_of: :enterprise, dependent: :destroy
  has_many :metrics_dashboards, inverse_of: :enterprise, dependent: :destroy
  has_many :user_roles, inverse_of: :enterprise, dependent: :delete_all
  delegate :leaders, to: :groups
  has_many :graphs, through: :metrics_dashboards
  has_many :poll_graphs, through: :polls, source: :graphs
  has_many :campaigns, dependent: :destroy
  has_many :questions, through: :campaigns
  has_many :answers, through: :questions
  has_many :answer_comments, through: :answers, source: :comments
  has_many :answer_upvotes, through: :answers, source: :votes
  has_many :resources, dependent: :destroy
  has_many :yammer_field_mappings, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_many :email_variables, class_name: 'EnterpriseEmailVariable', dependent: :destroy
  belongs_to :theme

  has_many :expenses, dependent: :destroy
  has_many :expense_categories, dependent: :destroy
  has_many :clockwork_database_events, dependent: :destroy

  # mentorship
  has_many :mentoring_interests, dependent: :destroy
  has_many :mentoring_requests, dependent: :destroy
  has_many :mentoring_sessions, dependent: :destroy
  has_many :mentoring_types, dependent: :destroy
  has_many :sponsors, as: :sponsorable, dependent: :destroy

  has_many :policy_group_templates, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :reward_actions, dependent: :destroy
  has_many :badges, dependent: :destroy
  has_many :group_categories, dependent: :destroy
  has_many :group_category_types, dependent: :destroy
  has_many :annual_budgets, dependent: :destroy

  has_one :custom_text, dependent: :destroy

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :mobile_fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :yammer_field_mappings, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :theme, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward_actions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :sponsors, reject_if: :all_blank, allow_destroy: true

  before_create :create_elasticsearch_only_fields
  before_validation :smart_add_url_protocol
  after_update :resolve_auto_archive_state, if: :no_expiry_age_set_and_auto_archive_true?

  validates_length_of :unit_of_expiry_age, maximum: 191
  validates_length_of :redirect_email_contact, maximum: 191
  validates_length_of :default_from_email_display_name, maximum: 191
  validates_length_of :default_from_email_address, maximum: 191
  validates_length_of :company_video_url, maximum: 191

  validates_length_of :privacy_statement, maximum: 65535
  validates_length_of :home_message, maximum: 65535
  validates_length_of :cdo_message, maximum: 65535
  validates_length_of :yammer_token, maximum: 191
  validates_length_of :saml_last_name_mapping, maximum: 191
  validates_length_of :saml_first_name_mapping, maximum: 191
  validates_length_of :idp_cert, maximum: 65535
  validates_length_of :idp_slo_target_url, maximum: 191
  validates_length_of :idp_sso_target_url, maximum: 191
  validates_length_of :idp_entity_id, maximum: 191
  validates_length_of :sp_entity_id, maximum: 191
  validates_length_of :name, maximum: 191
  validates :idp_sso_target_url, url: { allow_blank: true }

  # ActiveStorage
  has_one_attached :banner
  validates :banner, content_type: AttachmentHelper.common_image_types
  has_one_attached :cdo_picture
  validates :cdo_picture, content_type: AttachmentHelper.common_image_types
  has_one_attached :xml_sso_config
  validates :xml_sso_config, content_type: 'text/xml'
  has_one_attached :sponsor_media
  has_one_attached :onboarding_sponsor_media

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :banner_paperclip
  has_attached_file :cdo_picture_paperclip, s3_permissions: 'private'
  has_attached_file :xml_sso_config_paperclip
  has_attached_file :sponsor_media_paperclip, s3_permissions: 'private'
  has_attached_file :onboarding_sponsor_media_paperclip, s3_permissions: 'private'

  validates_format_of :redirect_email_contact, with: /\A[^@\s]+@[^@\s]+\z/, allow_blank: true

  def resolve_auto_archive_state
    update(auto_archive: false)
  end

  def no_expiry_age_set_and_auto_archive_true?
    true if auto_archive? && expiry_age_for_resources == 0
  end

  def archive_switch
    if auto_archive?
      update(auto_archive: false)
    else
      update(auto_archive: true)
    end
  end

  def custom_text
    super || create_custom_text
  end

  def default_time_zone
    return time_zone if time_zone.present?

    ActiveSupport::TimeZone.find_tzinfo('UTC').name
  end

  def default_user_role
    user_roles.find_by(default: true).id
  end

  def iframe_calendar_token
    unless self[:iframe_calendar_token]
      self.update(iframe_calendar_token: SecureRandom.urlsafe_base64)
    end

    self[:iframe_calendar_token]
  end

  def saml_settings
    # if xml config file is present - take settings from it
    if xml_sso_config.attached?
      # ActiveStorage
      idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
      file_content = xml_sso_config.download
      settings = idp_metadata_parser.parse(file_content)
    else # otherwise - initialize empty settings
      settings = OneLogin::RubySaml::Settings.new
      settings.name_identifier_format = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
    end

    settings.assertion_consumer_service_url = "#{ENV['DOMAIN']}/api/v1/enterprises/#{id}/sso_login"

    # override xml file settings with enterprise settings, if they are present
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
    enterprise.users.where.not(id: id).find_each do |other_user|
      CalculateMatchScoreJob.perform_later(self, other_user, skip_existing: false)
    end
  end

  def users_csv(nb_rows, export_csv_params = nil)
    group_roles = enterprise.user_roles.where(role_type: 'group').pluck(:role_name)
    non_group_roles = enterprise.user_roles.where.not(role_type: 'group').pluck(:role_name)

    return User.to_csv(users: users, fields: fields, nb_rows: nb_rows) if export_csv_params == 'all_users' || export_csv_params.nil?
    return User.to_csv(users: users.active, fields: fields, nb_rows: nb_rows) if export_csv_params == 'active_users'
    return User.to_csv(users: users.inactive, fields: fields, nb_rows: nb_rows) if export_csv_params == 'inactive_users'


    if group_roles.include?(export_csv_params)
      return User.to_csv(users: users.joins(group_leaders: :user_role).where(user_roles: { role_name: export_csv_params }).distinct, fields: fields, nb_rows: nb_rows)
    elsif non_group_roles.include?(export_csv_params)
      return User.to_csv(users: users.joins(:user_role).where(user_roles: { role_name: export_csv_params }).distinct, fields: fields, nb_rows: nb_rows)
    end

    User.to_csv(users: [], fields: fields, nb_rows: nb_rows)
  end

  def close_budgets_csv
    CSV.generate do |csv|
      csv << ['Group name', 'Annual budget', 'Leftover money', 'Approved budget']
      self.groups.includes(:children).all_parents.each do |group|
        csv << [group.name, group.annual_budget.presence || 'Not set', group.leftover_money, group.approved_budget]

        group.children.each do |child|
          csv << [child.name, child.annual_budget.presence || 'Not set', child.leftover_money, child.approved_budget]
        end
      end
    end
  end

  # Run an elasticsearch query on the enterprise's users
  def search_users(search_hash)
    Elasticsearch::Model.client.search(
        index: 'users',
        body: search_hash,
        search_type: 'count'
      )
  end

  # Necessary to be implement a graph container
  def enterprise
    self
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

          mapped_fields[field.id] = string_value
          next
        end
      end
    end

    mapped_fields
  end

  def resources_count
    enterprise_resources_count + groups_resources_count
  end

  def enterprise_resources_count
    Resource.where(folder_id: enterprise.folder_ids).count
  end

  def groups_resources_count
    group_folder_ids = Folder.where(group_id: enterprise.group_ids).pluck(:id)
    Resource.where(folder_id: group_folder_ids).count
  end

  def generic_graphs_group_population_csv(erg_text, from_date, to_date, scoped_by_models)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    groups = self.groups
    groups = groups.where(id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

    data = groups.map { |g|
      members = g.members.active
      members = members.where('user_groups.created_at >= ?', from_date) if from_date.present?
      members = members.where('user_groups.created_at <= ?', to_date) if to_date.present?

      {
          y: members.count,
          name: g.name,
          drilldown: g.name
      }
    }
    categories = groups.map(&:name)

    strategy = Reports::GraphStatsGeneric.new(title: "Number of users #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_group_growth_csv(from_date, to_date, scoped_by_models)
    CSV.generate do |csv|
      from_date_text = ''
      to_date_text = ''

      if from_date.present?
        from_date = from_date.to_datetime
        from_date_text = from_date.strftime('%F %T')
      else
        from_date_text = 'All'
      end

      if to_date.present?
        to_date = to_date.to_datetime + 1.hour
        to_date_text = to_date.strftime('%F %T')
      else
        to_date_text = 'All'
      end

      # column titles
      csv << [
        self.custom_text.send('erg_text'),
        'From: ' + from_date_text,
        'To: ' + to_date_text,
        'Difference',
        '% Change'
      ]

      groups = self.groups
      groups = groups.where(id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

      groups.each do |group|
        from_date_total = group.user_groups
        from_date_total = from_date_total.where('created_at <= ?', from_date) if from_date.present?
        from_date_total = from_date_total.count.to_f

        to_date_total = group.user_groups
        to_date_total = to_date_total.where('created_at <= ?', to_date) if to_date.present?
        to_date_total = to_date_total.count.to_f

        change_percentage = 0
        if (from_date_total == 0) && (to_date_total > 0)
          change_percentage = 100
        elsif (to_date_total == 0) && (from_date_total > 0)
          change_percentage = -100
        elsif (from_date_total == 0) && (to_date_total == 0)
          change_percentage = 0
        else
          change_percentage =
            (((to_date_total - from_date_total) / from_date_total)).round(2)
        end

        if change_percentage.positive?
          change_percentage = '+' + (change_percentage.to_s)
        end

        csv << [
          group.name, from_date_total, to_date_total,
          (to_date_total - from_date_total), change_percentage
        ]
      end
    end
  end

  def generic_graphs_segment_population_csv(erg_text)
    segments = self.segments.all_parents

    data = segments.map { |s|
      {
          y: s.members.active.count,
          name: s.name,
          drilldown: s.name
      }
    }
    categories = segments.map { |s| s.name }

    strategy = Reports::GraphStatsGeneric.new(title: "Number of users by #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_mentorship_csv(erg_text)
    data = self.groups.all_parents.map { |g|
      {
          y: g.members.active.mentors_and_mentees.count,
          name: g.name,
          drilldown: g.name
      }
    }
    categories = self.groups.all_parents.map { |g| g.name }

    strategy = Reports::GraphStatsGeneric.new(title: "Number of mentors/mentees #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_mentoring_sessions_csv(erg_text, from_date, to_date)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    data = self.groups.all_parents.map { |g|
      mentoring_sessions = g.members.active.mentors_and_mentees.joins(:mentoring_sessions)
      mentoring_sessions = mentoring_sessions.where('mentoring_sessions.created_at >= ?', from_date) if from_date.present?
      mentoring_sessions = mentoring_sessions.where('mentoring_sessions.created_at <= ?', to_date) if to_date.present?

      {
          y: mentoring_sessions.count,
          name: g.name,
          drilldown: g.name
      }
    }

    categories = self.groups.all_parents.map { |g| g.name }

    strategy = Reports::GraphStatsGeneric.new(title: "Number of mentoring sessions #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_mentoring_interests_csv
    data = self.mentoring_interests.includes(:users).map { |mi|
      {
          y: mi.users.count,
          name: mi.name,
          drilldown: nil
      }
    }
    categories = self.mentoring_interests.map { |mi| mi.name }

    strategy = Reports::GraphStatsGeneric.new(title: 'Mentoring Interests}', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_non_demo_events_created_csv(erg_text, from_date, to_date, scoped_by_models)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    groups = self.groups
    groups = groups.where(id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

    data = groups.map do |g|
      events = g.initiatives.joins(:owner)
            .where('users.active = ?', true)
      events = events.where('initiatives.created_at >= ?', from_date) if from_date.present?
      events = events.where('initiatives.created_at <= ?', to_date) if to_date.present?

      {
          y: events.count,
          name: g.name,
          drilldown: g.name
      }
    end

    categories = groups.map { |g| g.name }

    strategy = Reports::GraphStatsGeneric.new(title: "Number of events created #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_non_demo_messages_sent_csv(erg_text, from_date, to_date, scoped_by_models)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    groups = self.groups
    groups = groups.where(id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

    data = groups.map do |g|
      messages = g.messages.joins(:owner)
                  .where('users.active = ?', true)
      messages = messages.where('group_messages.created_at >= ?', from_date) if from_date.present?
      messages = messages.where('group_messages.created_at <= ?', to_date) if to_date.present?

      {
        y: messages.count,
        name: g.name,
        drilldown: g.name
      }
    end

    categories = groups.map { |g| g.name }

    strategy = Reports::GraphStatsGeneric.new(title: "Number of messages sent #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_non_demo_top_groups_by_views_csv(erg_text, from_date, to_date, scoped_by_models)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    groups = self.groups
    groups = groups.where(id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

    data = groups.map do |g|
      views = g.views
      views = views.where('views.created_at >= ?', from_date) if from_date.present?
      views = views.where('views.created_at <= ?', to_date) if to_date.present?

      {
          y: views.count,
          name: g.name,
          drilldown: g.name
      }
    end

    categories = groups.map { |g| g.name }

    strategy = Reports::GraphStatsGeneric.new(title: "Number of view per #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_non_demo_top_folders_by_views_csv(from_date, to_date, scoped_by_models)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    folders = Folder.all
    folders = folders.where(group_id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

    data = folders.map do |f|
      views = f.views
      views = views.where('views.created_at >= ?', from_date) if from_date.present?
      views = views.where('views.created_at <= ?', to_date) if to_date.present?

      {
        y: views.count,
        name: !f.group.nil? ? f.group.name + ': ' + f.name : 'Shared folder: ' + f.name,
        drilldown: f.name
      }
    end

    categories = folders.map { |f| f.name }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of view per folder', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_non_demo_top_resources_by_views_csv(from_date, to_date, scoped_by_models)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    groups = self.groups
    groups = groups.where(id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

    folder_ids = Folder.where(group_id: groups.ids).ids
    resources = Resource.where(folder_id: folder_ids)
    data = resources.map do |resource|
      views = resource.views
      views = views.where('views.created_at >= ?', from_date) if from_date.present?
      views = views.where('views.created_at <= ?', to_date) if to_date.present?

      {
          y: views.count,
          name: resource.title
      }
    end

    categories = resources.map { |r| r.title }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of view per resource', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_non_demo_top_news_by_views_csv(from_date, to_date, scoped_by_models)
    from_date = from_date.to_datetime if from_date.present?
    to_date = to_date.to_datetime if to_date.present?

    groups = self.groups
    groups = groups.where(id: scoped_by_models) if scoped_by_models.present? && !scoped_by_models.empty?

    news_feed_link_ids = NewsFeedLink.where(news_feed_id: NewsFeed.where(group_id: groups.ids).ids).ids
    news_links = NewsLink
      .select('DISTINCT news_links.id, news_links.title, groups.name')
      .joins(:group, :news_feed_link, 'JOIN views on news_feed_links.id = views.news_feed_link_id')
      .where(news_feed_links: { id: news_feed_link_ids })

    news_links = news_links.where('views.created_at >= ?', from_date) if from_date.present?
    news_links = news_links.where('views.created_at <= ?', to_date) if to_date.present?

    data = news_links.map do |news_link|
      {
          y: news_link.total_views,
          name: news_link.name + ': ' + news_link.title
      }
    end

    categories = news_links.map { |r| r.title }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of view per news link', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_demo_events_created_csv
    categories = self.groups.map(&:name)

    values = [2, 3, 4, 1, 6, 8, 5, 8, 3, 4, 1, 5]
    i = 0
    data = self.groups.map { |g| g.initiatives.where('initiatives.created_at > ?', 1.month.ago).count + values[i += 1] }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of events created ERG', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_demo_messages_sent_csv
    categories = self.groups.map(&:name)

    values = [3, 2, 5, 1, 7, 10, 9, 5, 11, 4, 1, 5]
    i = 0
    data = self.groups.map { |g| g.messages.where('created_at > ?', 1.month.ago).count + values[i += 1] }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of messages sent ERG', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_demo_top_groups_by_views_csv(erg_text)
    values = [8, 1, 2, 1, 7, 5, 9, 5, 11, 7, 6, 2]
    i = 0
    data = self.groups.all_parents.map do |g|
      {
          y: values[i += 1],
          name: g.name
      }
    end

    categories = self.groups.all_parents.map { |g| g.name }

    strategy = Reports::GraphStatsGeneric.new(title: "Number of view per #{erg_text}", categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_demo_top_folders_by_views_csv
    group_ids = self.groups.ids
    folders = Folder.where(group_id: group_ids).only_parents

    values = [5, 2, 5, 1, 7, 1, 4, 5, 11, 4, 3, 8]
    i = 0

    data = folders.map do |f|
      {
          y: values[i += 1],
          name: f.name,
          drilldown: f.name
      }
    end

    categories = folders.map { |f| f.name }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of view per folder', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_demo_top_resources_by_views_csv
    group_ids = self.groups.ids
    folder_ids = Folder.where(group_id: group_ids).ids
    resources = Resource.where(folder_id: folder_ids)

    values = [4, 2, 5, 4, 7, 4, 9, 5, 11, 4, 1, 5]
    i = 0

    data = resources.map do |resource|
      {
          y: values[i += 1],
          name: resource.title
      }
    end

    categories = resources.map { |r| r.title }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of view per resource', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def generic_graphs_demo_top_news_by_views_csv
    news_feed_link_ids = NewsFeedLink.where(news_feed_id: NewsFeed.where(group_id: self.groups.ids).ids).ids
    news_links = NewsLink.select('news_links.title, SUM(views.id) view_count')
                   .joins(:news_feed_link, news_feed_link: :views)
                   .where(news_feed_links: { id: news_feed_link_ids })
                   .order('view_count DESC')

    values = [9, 2, 5, 1, 11, 10, 9, 5, 11, 4, 1, 8]
    i = 0

    data = news_links.map do |news_link|
      {
          y: values[i += 1],
          name: news_link.title
      }
    end

    categories = news_links.map { |r| r.title }

    strategy = Reports::GraphStatsGeneric.new(title: 'Number of view per news link', categories: categories, data: data)
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def users_date_histogram_csv
    g = DateHistogramGraph.new(
      # index: User.es_index_name(enterprise: self),
      field: 'created_at',
      interval: 'month'
    )

    data = g.query_elasticsearch

    strategy = Reports::GraphTimeseriesGeneric.new(
      title: 'Number of employees',
      data: data['aggregations']['my_date_histogram']['buckets'].collect { |d| [d['key'], d['doc_count']] }
    )
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def logs_csv
    logs = PublicActivity::Activity.includes(:owner, :trackable).where(recipient: self).order(created_at: :desc)
    LogCsv.build(logs)
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
