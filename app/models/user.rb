class User < ActiveRecord::Base
    devise :database_authenticatable, :invitable, :lockable,
           :recoverable, :rememberable, :trackable, :validatable, :async, :timeoutable

    include PublicActivity::Common
    include DeviseTokenAuth::Concerns::User
    include Elasticsearch::Model
    include ContainsFields
    include Indexable

    @@fb_token_generator = Firebase::FirebaseTokenGenerator.new(ENV['FIREBASE_SECRET'].to_s)

    scope :active,              -> { where(active: true).distinct }
    scope :enterprise_mentors,  -> ( user_ids = []) { where(mentor: true).where.not(:id => user_ids) }
    scope :enterprise_mentees,  -> ( user_ids = []) { where(mentee: true).where.not(:id => user_ids) }
    scope :mentors_and_mentees, -> { where("mentor = true OR mentee = true").distinct }
    scope :inactive,            -> { where(active: false).distinct }

    belongs_to :enterprise, inverse_of: :users
    belongs_to :policy_group
    
    # mentorship
    has_many :mentorships,       class_name: "Mentoring", foreign_key: "mentor_id"
    has_many :mentees, through: :mentorships, class_name: 'User', source: :mentee
    has_many :menteeships,       class_name: "Mentoring", foreign_key: "mentee_id"
	has_many :mentors, through: :menteeships, class_name: 'User', source: :mentor
	has_many :availabilities,   :class_name => "MentorshipAvailability"
    has_many :mentorship_ratings
        
    # many to many
    has_many :mentorship_interests
    has_many :mentoring_interests, :through => :mentorship_interests
    
    has_many :mentorship_sessions
    has_many :mentoring_sessions, :through => :mentorship_sessions

	has_many :mentorship_types
	has_many :mentoring_types, :through => :mentorship_types

    # mentorship_requests
    has_many :mentorship_requests,  :foreign_key => "sender_id",     :class_name => "MentoringRequest"
    has_many :mentorship_proposals, :foreign_key => "receiver_id",   :class_name => "MentoringRequest"
    
    has_many :devices
    has_many :users_segments
    has_many :segments, through: :users_segments
    has_many :user_groups, dependent: :destroy
    has_many :groups, through: :user_groups
    has_many :topic_feedbacks
    has_many :poll_responses
    has_many :answers, inverse_of: :author, foreign_key: :author_id
    has_many :answer_upvotes, foreign_key: :author_id
    has_many :answer_comments, foreign_key: :author_id
    has_many :invitations, class_name: 'CampaignInvitation'
    has_many :campaigns, through: :invitations
    has_many :news_links, through: :groups
    has_many :own_news_links, class_name: 'NewsLink', foreign_key: :author_id
    has_many :messages, through: :groups
    has_many :message_comments, class_name: 'GroupMessageComment', foreign_key: :author_id
    has_many :events, through: :groups
    has_many :social_links, foreign_key: :author_id, dependent: :destroy
    has_many :initiative_users
    has_many :initiatives, through: :initiative_users, source: :initiative
    has_many :initiative_invitees
    has_many :invited_initiatives, through: :initiative_invitees, source: :initiative
    has_many :event_attendances
    has_many :attending_events, through: :event_attendances, source: :event
    has_many :event_invitees
    has_many :invited_events, through: :event_invitees, source: :event
    has_many :managed_groups, foreign_key: :manager_id, class_name: 'Group'
    has_many :samples
    has_many :biases, class_name: "Bias"
    has_many :group_leaders
    has_many :leading_groups, through: :group_leaders, source: :group
    has_many :user_reward_actions
    has_many :reward_actions, through: :user_reward_actions
    has_many :likes, dependent: :destroy

    has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing_user.png'), s3_permissions: "private"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :points, numericality: { only_integer: true }, presence: true
    validates :credits, numericality: { only_integer: true }, presence: true
    validate :validate_presence_fields

    before_validation :generate_password_if_saml
    before_validation :set_provider
    before_validation :set_uid
    before_destroy :check_lifespan_of_user

    before_save :assign_policy_group, if: Proc.new { |user| user[:policy_group_id].nil? }
    after_create :assign_firebase_token

    after_commit on: [:create] { update_elasticsearch_index(self, self.enterprise, 'index') }
    after_commit on: [:update] { update_elasticsearch_index(self, self.enterprise, 'update') }
    after_commit on: [:destroy] { update_elasticsearch_index(self, self.enterprise, 'delete') }

    scope :for_segments, -> (segments) { joins(:segments).where('segments.id' => segments.map(&:id)).distinct if segments.any? }
    scope :for_groups, -> (groups) { joins(:groups).where('groups.id' => groups.map(&:id)).distinct if groups.any? }
    scope :answered_poll, -> (poll) { joins(:poll_responses).where(poll_responses: { poll_id: poll.id }) }
    scope :top_participants, -> (n) { order(total_weekly_points: :desc).limit(n) }
    scope :not_owners, -> { where(owner: false) }
    scope :es_index_for_enterprise, -> (enterprise) { where(enterprise: enterprise) }
    scope :active, -> {where(active: true)}
    scope :mentors, -> {where(mentor: true)}
    scope :mentees, -> {where(mentee: true)}
    
    accepts_nested_attributes_for :availabilities, :allow_destroy => true
    
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

    def default_time_zone
        return time_zone if time_zone.present?

        enterprise.default_time_zone
    end

    def name_with_status
        status = !active ? " (inactive)" : ""
        name + status
    end

    def badges
        Badge.where("points <= ?", points).order(points: :asc)
    end

    def policy_group
        assign_policy_group if self[:policy_group_id].nil?

        PolicyGroup.find_by_id(self[:policy_group_id])
    end

    def has_answered_group_surveys?
        groups_with_answered_surveys = user_groups.where.not(data: nil)

        if groups_with_answered_surveys.count > 0
            return true
        else
            return false
        end
    end

    def has_answered_group_survey?(group)
        user_group = user_groups.find_by_group_id(group.id)

        if user_group.present? && user_group.data.present?
            return true
        else
            return false
        end
    end

    #Return true if user is a leader of at least 1 group
    def erg_leader?
        g = groups.includes(:leaders).select do |group|
            group.leaders.include? self
        end

        g.present?
    end

    def manageable_groups
        manageable_groups = enterprise.groups.select do |group|
            policy = Pundit.policy(self, group)

            policy.erg_leader_permissions?
        end
    end

    # Update the user with info from the SAML auth response
    def set_info_from_saml(nameid, _attrs, enterprise)
        self.email = nameid

        set_name_from_saml(_attrs, enterprise)

        saml_user_info = enterprise.sso_fields_to_enterprise_fields(_attrs)

        self.update_info(saml_user_info)
        save!

        self
    end

    #when using self.info.erge form_data argument expects _all_ enterprise fields to be present
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

        segment.rules.each do |rule|
            unless rule.followed_by?(self)
                part_of_segment = false
                break
            end
        end

        part_of_segment
    end

    # Sends a push notification to all of the user's devices
    def notify(message, data)
        devices.each do |device|
            device.notify(message, data)
        end
    end

    # Generate a Firebase token for the user and update the user with it
    def assign_firebase_token
        payload = { uid: id.to_s }
        options = { expires: 1.week.from_now }
        self.firebase_token = @@fb_token_generator.create_token(payload, options)
        self.firebase_token_generated_at = Time.current
        save
    end

    # Updates this user's match scores with all other enterprise users
    def update_match_scores
        enterprise.users.where.not(id: id).each do |other_user|
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
            csv << ['First name', 'Last name', 'Email', 'Biography', 'Active'].concat(fields.map(&:title))

            users.order(created_at: :desc).limit(nb_rows).each do |user|
                user_columns = [user.first_name, user.last_name, user.email, user.biography, user.active]

                fields.each do |field|
                    user_columns << field.csv_value(user.info[field])
                end

                csv << user_columns
            end
        end
    end

    def group_member?(group_id)
        user_group = user_groups.where(group_id: group_id).first
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
        groups.joins(:user_groups).where(:user_groups => {:user => self, :accepted_member => true})
    end

    def active_for_authentication?
        super && active?
    end

    # Elasticsearch methods

    # Returns the index name to be used in Elasticsearch to store this enterprise's users
    def self.es_index_name(enterprise:)
        "#{enterprise.id}_users"
    end

    # Add the combined info from both the user's fields and his/her poll answers to ES
    def as_indexed_json(*)
        as_json(except: [:data], methods: [:combined_info])
    end

    # Returns a hash of all the user's fields combined with all their poll fields
    def combined_info
        polls_hash = poll_responses.map(&:info).reduce({}) { |a, e| a.merge(e) } # Get a hash of all the combined poll response answers for this user
        groups_hash = { groups: groups.ids }
        segments_hash = { segments: segments.ids }

        # Merge all the hashes to the main info hash
        # We use info_hash instead of just info because Hash#merge accesses uses [], which is overriden in FieldData
        info_hash.merge(polls_hash).merge(groups_hash).merge(segments_hash)
    end

    # Custom ES mapping that creates an unanalyzed version of all string fields for exact-match term queries
    def self.custom_mapping
        {
            user: {
                dynamic_templates: [{
                    string_template: {
                        type: 'string',
                        mapping: {
                            fields: {
                                raw: {
                                    type: 'string',
                                    index: 'not_analyzed'
                                }
                            }
                        },
                        match_mapping_type: 'string',
                        match: '*'
                    }
                }],
                properties: {}
            }
        }
    end

    def set_provider
        self.provider = "email" if uid.nil?
    end

    def set_uid
        self.uid = generate_uid if self.uid.blank?
    end

    private

    def check_lifespan_of_user
        # deletes users 13 days or younger
        DateTime.now.days_ago(14) < self.created_at
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
            break uid unless User.where(uid: uid).first
        end
    end

    # Generate a random password if the user is using SAML
    def generate_password_if_saml
        self.password = self.password_confirmation = SecureRandom.urlsafe_base64 if auth_source == 'saml' && new_record?
    end

    def assign_policy_group
        current_policy_group = PolicyGroup.find_by_id(self[:policy_group_id])

        if current_policy_group.nil?
            self[:policy_group_id] = PolicyGroup.default_group(enterprise.id)&.id
        end
    end
end
