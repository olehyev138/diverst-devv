class User < ApplicationRecord
  has_secure_password

  include PublicActivity::Common
  include User::Actions
  include ContainsFields
  include TimeZoneValidation

  enum groups_notifications_frequency: [:hourly, :daily, :weekly, :disabled]
  enum groups_notifications_date: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  scope :active,              -> { where(active: true).distinct }
  scope :enterprise_mentors,  -> (user_ids = []) { where(mentor: true).where.not(id: user_ids).where.not(accepting_mentor_requests: false) }
  scope :enterprise_mentees,  -> (user_ids = []) { where(mentee: true).where.not(id: user_ids).where.not(accepting_mentee_requests: false) }
  scope :mentors_and_mentees, -> { where('mentor = true OR mentee = true').distinct }
  scope :inactive,            -> { where(active: false).distinct }


  belongs_to  :enterprise
  belongs_to  :user_role

  has_one :policy_group,  dependent: :destroy, inverse_of: :user
  has_one :device,        dependent: :destroy, inverse_of: :user

  has_many :field_data, class_name: 'FieldData'

  # sessions
  has_many :sessions, dependent: :destroy

  # mentorship
  has_many :mentorships, class_name: 'Mentoring', foreign_key: 'mentor_id'
  has_many :mentees, through: :mentorships, class_name: 'User', source: :mentee
  has_many :menteeships, class_name: 'Mentoring', foreign_key: 'mentee_id'
  has_many :mentors, through: :menteeships, class_name: 'User', source: :mentor
  has_many :availabilities,   class_name: 'MentorshipAvailability'
  has_many :mentorship_ratings

  # many to many
  has_many :mentorship_interests
  has_many :mentoring_interests, through: :mentorship_interests

  has_many :mentorship_sessions
  has_many :mentoring_sessions, through: :mentorship_sessions

  has_many :mentorship_types
  has_many :mentoring_types, through: :mentorship_types

  # mentorship_requests
  has_many :mentorship_proposals, foreign_key: 'sender_id',     class_name: 'MentoringRequest'
  has_many :mentorship_requests,  foreign_key: 'receiver_id',   class_name: 'MentoringRequest'

  has_many :users_segments, dependent: :destroy
  has_many :segments, through: :users_segments
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :topic_feedbacks, dependent: :destroy
  has_many :poll_responses
  has_many :answers, inverse_of: :author, foreign_key: :author_id, dependent: :destroy
  has_many :answer_upvotes, foreign_key: :author_id, dependent: :destroy
  has_many :answer_comments, foreign_key: :author_id, dependent: :destroy
  has_many :invitations, class_name: 'CampaignInvitation', dependent: :destroy
  has_many :campaigns, through: :invitations
  has_many :news_links, through: :groups
  has_many :own_news_links, class_name: 'NewsLink', foreign_key: :author_id, dependent: :destroy
  has_many :messages, through: :groups
  has_many :message_comments, class_name: 'GroupMessageComment', foreign_key: :author_id, dependent: :destroy
  has_many :social_links, foreign_key: :author_id, dependent: :destroy
  has_many :initiative_users, dependent: :destroy
  has_many :initiatives, through: :initiative_users, source: :initiative
  has_many :initiative_invitees, dependent: :destroy
  has_many :invited_initiatives, through: :initiative_invitees, source: :initiative
  has_many :managed_groups, foreign_key: :manager_id, class_name: 'Group'
  has_many :group_leaders, dependent: :destroy
  has_many :leading_groups, through: :group_leaders, source: :group
  has_many :user_reward_actions, dependent: :destroy
  has_many :reward_actions, through: :user_reward_actions
  has_many :rewards, foreign_key: :responsible_id, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :csv_files
  has_many :metrics_dashboards, foreign_key: :owner_id
  has_many :shared_metrics_dashboards

  # ActiveStorage
  has_one_attached :avatar
  validates :avatar, content_type: AttachmentHelper.common_image_types

  validates_length_of :mentorship_description, maximum: 65535
  validates_length_of :unlock_token, maximum: 191
  validates_length_of :time_zone, maximum: 191
  validates_length_of :biography, maximum: 65535
  validates_length_of :linkedin_profile_url, maximum: 191
  validates_length_of :yammer_token, maximum: 191
  validates_length_of :firebase_token, maximum: 191
  validates_length_of :tokens, maximum: 65535
  validates_length_of :uid, maximum: 191
  validates_length_of :provider, maximum: 191
  validates_length_of :invited_by_type, maximum: 191
  validates_length_of :invitation_token, maximum: 191
  validates_length_of :last_sign_in_ip, maximum: 191
  validates_length_of :current_sign_in_ip, maximum: 191
  validates_length_of :reset_password_token, maximum: 191
  validates_length_of :email, maximum: 191
  validates_length_of :auth_source, maximum: 191
  validates_length_of :data, maximum: 65535
  validates_length_of :last_name, maximum: 191
  validates_length_of :first_name, maximum: 191

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates_presence_of   :email
  validates_uniqueness_of :email, allow_blank: false, if: :email_changed?
  validates_format_of     :email, with: /\A[^@\s]+@[^@\s]+\z/, allow_blank: false, if: :email_changed?

  validates_presence_of   :password, on: create
  validates_length_of     :password, within: 8..128, allow_blank: true

  validate :user_role_presence
  validates :points, numericality: { only_integer: true }, presence: true
  validates :credits, numericality: { only_integer: true }, presence: true
  validate :validate_presence_fields
  validate :group_leader_role
  validate :policy_group
  before_validation :add_linkedin_http, unless: -> { linkedin_profile_url.nil? }
  validate :valid_linkedin_url, unless: -> { linkedin_profile_url.nil? }

  before_validation :generate_password_if_saml
  before_validation :set_provider
  before_validation :set_uid
  before_destroy :check_lifespan_of_user

  # after_create :assign_firebase_token
  after_create :set_default_policy_group
  after_save :set_default_policy_group, if: :user_role_id_changed?
  accepts_nested_attributes_for :policy_group

  after_update :add_to_default_mentor_group

  # Default values
  after_initialize do
    if self.new_record?
      self.time_zone ||= self.enterprise&.default_time_zone || ActiveSupport::TimeZone.find_tzinfo('UTC').name
    end
  end

  scope :for_segments, -> (segments) { joins(:segments).where('segments.id' => segments.map(&:id)).distinct if segments.any? }
  scope :for_groups, -> (groups) { joins(:groups).where('groups.id' => groups.map(&:id)).distinct if groups.any? }
  scope :answered_poll, -> (poll) { joins(:poll_responses).where(poll_responses: { poll_id: poll.id }) }
  scope :top_participants, -> (n) { order(total_weekly_points: :desc).limit(n) }
  scope :not_owners, -> { where(owner: false) }
  scope :es_index_for_enterprise, -> (enterprise) { where(enterprise: enterprise) }
  scope :active, -> { where(active: true) }
  scope :mentors, -> { where(mentor: true) }
  scope :mentees, -> { where(mentee: true) }

  accepts_nested_attributes_for :availabilities, allow_destroy: true

  # All user fields for the users enterprise
  # TODO: filter on type: 'user'
  def fields
    self.enterprise.fields
  end

  # Format users field data for a ES index
  # Returns { <field_data.id> => <field_data.data } }
  def indexed_field_data
    field_data.to_h { |fd| [fd.field_id, fd.data] }
  end

  def avatar_location(expires_in: 3600, default_style: :medium)
    return nil if !avatar.attached?

    # default_style = :medium if !avatar.styles.keys.include? default_style
    # avatar.expiring_url(expires_in, default_style)
    Rails.application.routes.url_helpers.url_for(avatar)
  end

  def generate_authentication_token(length = 20)
    loop do
      rlength = (length * 3) / 4
      token = SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
      break token unless Session.find_by(token: token)
    end
  end

  def valid_password?(password)
    authenticate(password) == self
  end

  def last_notified_date
    last_group_notification_date&.to_date
  end

  def add_to_default_mentor_group
    if saved_change_to_mentor? || saved_change_to_mentee?
      DefaultMentorGroupMemberUpdateJob.perform_later(id, mentor, mentee)
    end
  end

  def is_group_leader_of?(group)
    group.group_leaders.where(user_id: self.id).any?
  end

  def is_member_of?(group)
    group.user_groups.where(user_id: self.id).any?
  end

  def is_not_member_of?(group)
    !is_member_of?(group)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def last_initial
    "#{(last_name || '')[0].capitalize}."
  end

  def user_role_presence
    if user_role_id.nil?
      self.user_role_id = enterprise.default_user_role
    end
  end

  def group_leader_role
    # make sure a user's role cannot be set to group_leader
    if enterprise.user_roles.where(id: user_role_id, role_type: 'group').count > 0 && !erg_leader?
      errors.add(:user_role_id, 'Cannot set user role to a group role')
    end
  end

  def default_time_zone
    return time_zone if time_zone.present?

    enterprise.default_time_zone
  end

  def name_with_status
    status = !active ? ' (inactive)' : ''
    name + status
  end

  def badges
    Badge.where('points <= ?', points).order(points: :asc)
  end

  def set_default_policy_group
    template = enterprise.policy_group_templates.joins(:user_role).find_by(user_roles: { id: user_role_id })
    attributes = template.create_new_policy
    if policy_group.nil?
      create_policy_group(attributes)
    else
      # we don't update custom_policy_groups
      return if custom_policy_group

      policy_group.update_attributes(attributes)
    end
  end

  def is_admin?
    enterprise.user_roles.where(id: user_role_id).where("LOWER(role_type) = 'admin'").count > 0
  end

  def has_answered_group_survey?(group: nil)
    if group.present?
      user_group = user_groups.find_by_group_id(group.id)
      user_group.present? && user_group.data.present?
    else
      groups_with_answered_surveys = user_groups.where.not(data: nil)
      groups_with_answered_surveys.count > 0
    end
  end

  def belongs_to_group_with_survey?(group: nil)
    if group.present?
      group.has_survey?
    else
      groups.any? { |grp| grp.has_survey? }
    end
  end

  # Return true if user is a leader of at least 1 group
  def erg_leader?
    group_leaders.count > 0
  end

  def manageable_groups
    enterprise.groups.select do |group|
      Pundit.policy(self, group).manage?
    end
  end

  # Update the user with info from the SAML auth response
  def set_info_from_saml(nameid, _attrs, enterprise)
    self.email = nameid

    set_name_from_saml(_attrs, enterprise)

    saml_user_info = enterprise.sso_fields_to_enterprise_fields(_attrs)

    self.update_info(saml_user_info)
    save(validate: false)

    self
  end

  # when using self.info.erge form_data argument expects _all_ enterprise fields to be present
  def update_info(fields_info = {})
    user_info = {}

    # We need to copy user info to separate hash that has no mixins
    self.info.each do |i|
      user_info[i[0]] = i[1]
    end

    merged_info = user_info.merge(fields_info)

    self.info.merge(fields: self.enterprise.fields, form_data: merged_info)
  end

  def set_name_from_saml(_attrs, enterprise)
    self.first_name ||= 'Not set'
    if enterprise.saml_first_name_mapping.present? && _attrs[enterprise.saml_first_name_mapping]
      self.first_name = _attrs[enterprise.saml_first_name_mapping]
    end

    self.last_name ||= 'Not set'
    if enterprise.saml_last_name_mapping.present? && _attrs[enterprise.saml_last_name_mapping]
      self.last_name = _attrs[enterprise.saml_last_name_mapping]
    end
  end

  def string_for_field(field)
    field.string_value info[field]
  end

  # Get the match score between the user and `other_user`
  def match_score_with(other_user)
    weight_total = 0
    total_score = 0

    users = enterprise.users.select([:id, :data]).all
    enterprise.match_fields.each do |field|
      field_score = field.match_score_between(self, other_user, users)
      unless field_score.nil? || field_score.nan?
        weight_total += field.match_weight
        total_score += field.match_weight * field_score
      end
    end

    begin
      total_score / weight_total
    rescue ZeroDivisionError
      0
    end
  end

  def matches
    Match.has_user(self)
  end

  def active_matches
    Match.active_for(self).not_archived
  end

  # Get the n top unswiped matches for the user
  def top_matches(n = 10)
    active_matches
        .includes(:topic,
                  user1: {
                      enterprise: {
                          mobile_fields: :field
                      }
                  },
                  user2: {
                      enterprise: {
                          mobile_fields: :field
                      }
                  })
        .order(score: :desc).limit(n)
  end

  # Checks if the user is part of the specified segment
  def is_part_of_segment?(segment)
    part_of_segment = true

    if !segment.general_rules_followed_by?(self)
      return false
    end

    segment.field_rules.each do |rule|
      unless rule.followed_by?(self)
        part_of_segment = false
        break
      end
    end

    part_of_segment
  end

  # Generate a Firebase token for the user and update the user with it
  #  def assign_firebase_token
  #    payload = { uid: id.to_s }
  #    options = { expires: 1.week.from_now }
  #    self.firebase_token = @@fb_token_generator.create_token(payload, options)
  #    self.firebase_token_generated_at = Time.current
  #    save
  #  end

  # Updates this user's match scores with all other enterprise users
  def update_match_scores
    enterprise.users.where.not(id: id).find_each do |other_user|
      CalculateMatchScoreJob.perform_later(self, other_user, skip_existing: false)
    end
  end

  # Initializes a user from a yammer user
  def self.from_yammer(yammer_user, enterprise:)
    user = User.new(
      first_name: yammer_user['first_name'],
      last_name: yammer_user['last_name'],
      email: yammer_user['contact']['email_addresses'][0]['address'],
      auth_source: 'yammer',
      enterprise: enterprise
    )

    # Map Yammer fields with Diverst fields as per the mappings defined in the integration configuration
    enterprise.yammer_field_mappings.each do |mapping|
      yammer_value = yammer_user[mapping.yammer_field_name]
      user.info[mapping.diverst_field] = yammer_value unless yammer_value.nil?
    end

    user
  end

  # Is set to false to allow users to login via SAML without a password
  def password_required?
    false
  end

  # Raw hash of user info needed when the FieldData Hash[] overrides are an annoyance
  def info_hash
    return {} if data.nil?

    JSON.parse data
  end

  # Export a CSV with the specified users
  def self.to_csv(users:, fields:, nb_rows: nil)
    CSV.generate do |csv|
      csv << ['First name', 'Last name', 'Email', 'Biography', 'Active', 'Group Membership'].concat(fields.map(&:title))

      users.order(created_at: :desc).limit(nb_rows).each do |user|
        user_columns = [user.first_name, user.last_name, user.email, user.biography, user.active, user.groups.map(&:name).join(',')]

        fields.each do |field|
          user_columns << field.csv_value(user.info[field])
        end

        csv << user_columns
      end
    end
  end

  # Export a CSV with the specified users
  def self.basic_info_to_csv(users:, nb_rows: nil)
    CSV.generate do |csv|
      csv << ['First name', 'Last name', 'Email']

      users.order(created_at: :desc).limit(nb_rows).each do |user|
        user_columns = [user.first_name, user.last_name, user.email]

        csv << user_columns
      end
    end
  end

  def group_member?(group_id)
    user_group = user_groups.find_by(group_id: group_id)
    user_group.present?
  end

  def pending_group_member?(group_id)
    return false unless group_member?(group_id)

    group = self.enterprise.groups.find(group_id)
    group.pending_members.exists? self.id
  end

  def active_group_member?(group_id)
    return false unless group_member?(group_id)

    group = self.enterprise.groups.find(group_id)
    group.active_members.exists? self.id
  end

  # groups where user is an accepted member
  def active_groups
    groups.joins(:user_groups).where(user_groups: { user: self, accepted_member: true })
  end

  def active_for_authentication?
    super && active?
  end

  def set_provider
    self.provider = 'email' if uid.nil?
  end

  def set_uid
    self.uid = generate_uid if self.uid.blank?
  end

  # Returns a hash of all the user's fields combined with all their poll fields
  def combined_info
    polls_hash = poll_responses.map(&:info).reduce({}) { |a, e| a.merge(e) } # Get a hash of all the combined poll response answers for this user

    # Merge all the hashes to the main info hash
    # We use info_hash instead of just info because Hash#merge accesses uses [], which is overriden in FieldData
    # info_hash.merge(polls_hash)
    info_hash.merge(polls_hash)
  end

  settings do
    #      mappings dynamic: false do
    mappings dynamic_templates: [
      {
        string_template: {
          match_mapping_type: 'string',
          match: '*',
          mapping: {
            type: 'keyword',
            #              fields: {
            #                raw: {
            #                  type: 'keyword',
            #                  index: 'not_analyzed'
            #                }
            #              }
          }
        }
      }
    ] do
      indexes :id,                    type: :integer
      indexes :first_name,            type: :keyword
      indexes :last_name,             type: :keyword
      indexes :email,                 type: :keyword
      indexes :sign_in_count,         type: :integer
      indexes :enterprise_id,         type: :integer
      indexes :created_at,            type: :date

      indexes :current_sign_in_at,    type: :date
      indexes :last_sign_in_at,       type: :date
      indexes :current_sign_in_ip,    type: :date
      indexes :last_sign_in_ip,       type: :date

      indexes :invitation_created_at,     type: :date
      indexes :invitation_sent_at,        type: :date
      indexes :invitation_accepted_at,    type: :date
      indexes :invited_by_id,             type: :integer

      indexes :active,                type: :boolean
      indexes :points,                type: :integer
      indexes :total_weekly_points,   type: :integer
      indexes :credits,               type: :integer

      indexes :failed_attempts,       type: :integer

      indexes :custom_policy_group,   type: :boolean
      indexes :mentor,                type: :boolean
      indexes :mentee,                type: :boolean

      indexes :groups_notifications_frequency,    type: :integer
      indexes :groups_notifications_date,         type: :integer

      indexes :time_zone,     type: :keyword
      indexes :created_at,    type: :date
      indexes :updated_at,    type: :date

      indexes :user_groups, type: :nested do
        indexes :group do
          indexes :name, type: :keyword
        end
      end

      indexes :users_segments, type: :nested do
        indexes :segment do
          indexes :name, type: :keyword
        end
      end

      indexes :enterprise do
        indexes :id, type: :integer
        indexes :name,              type: :keyword
        indexes :time_zone,         type: :keyword

        indexes :has_enabled_saml,              type: :boolean
        indexes :collaborate_module_enabled,    type: :boolean
        indexes :scope_module_enabled,          type: :boolean
        indexes :plan_module_enabled,           type: :boolean
        indexes :enable_rewards,                type: :boolean
        indexes :enable_pending_comments,       type: :boolean
        indexes :mentorship_module_enabled,     type: :boolean
        indexes :disable_likes,                 type: :boolean
        indexes :enable_social_media,           type: :boolean

        indexes :created_at,        type: :date
        indexes :updated_at,        type: :date
      end

      # enterprise
      # user role
      # groups
      # segments
      # group leaders
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      {
          only: [:id, :first_name, :last_name, :email, :sign_in_count, :enterprise_id,
                 :created_at, :mentor, :mentee, :created_at, :updated_at, :time_zone],
          methods: [:combined_info],
          include: [:enterprise, user_groups: { only: [], include: { group: { only: [:name] } } }]
        }
    ).merge({ 'created_at' => self.created_at.beginning_of_hour })
  end

  def delete_linkedin_info
    self.update(
      linkedin_profile_url: nil,
    )
    avatar.purge_later
  end

  private

  def check_lifespan_of_user
    # deletes users 14 days or younger
    return true if DateTime.now.days_ago(14) < self.created_at

    errors.add(:base, 'Users older then 14 days cannot be destroyed')
    throw(:abort)
  end

  def validate_presence_fields
    enterprise.try(:fields).to_a.each do |field|
      if field.required && info[field].blank?
        key = field.title.parameterize.underscore.to_sym
        errors.add(key, "can't be blank")
      end
    end
  end

  def generate_uid
    loop do
      uid = SecureRandom.uuid
      break uid unless User.find_by(uid: uid)
    end
  end

  # Generate a random password if the user is using SAML
  def generate_password_if_saml
    self.password = self.password_confirmation = SecureRandom.urlsafe_base64 if auth_source == 'saml' && new_record?
  end

  def add_linkedin_http
    unless linkedin_profile_url.downcase.start_with? 'http'
      self.linkedin_profile_url = "http://#{linkedin_profile_url}"
    end
  end

  def valid_linkedin_url
    uri = URI.parse(linkedin_profile_url) rescue nil

    if uri == nil
      errors.add(:user, 'Not a valid URL')
      return
    end

    unless uri.host.include?('linkedin.com')
      errors.add(:user, 'Not a valid LinkedIn URL')
      return
    end

    unless uri.path.start_with?('/in/')
      errors.add(:user, 'Not a valid LinkedIn Profile URL')
      return
    end
  end
end
