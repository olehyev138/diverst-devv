class Group < ActiveRecord::Base
  include PublicActivity::Common

  extend Enumerize

  enumerize :pending_users, default: :disabled,  in: [
                              :disabled,
                              :enabled
                            ]

  enumerize :members_visibility, default: :managers_only, in:[
                                   :global,
                                   :group,
                                   :managers_only
                                 ]

  enumerize :messages_visibility, default: :managers_only, in:[
                                    :global,
                                    :group,
                                    :managers_only
                                  ]

enumerize :latest_news_visibility, default: :leaders_only, in:[
                                    :public,
                                    :group,
                                    :leaders_only
                                  ]

enumerize :upcoming_events_visibility, default: :leaders_only, in:[
                                    :public,
                                    :group,
                                    :leaders_only
                                  ]

  belongs_to :enterprise
  belongs_to :lead_manager, class_name: "User"
  belongs_to :owner, class_name: "User"

  has_one :news_feed, dependent: :destroy

  delegate :news_feed_links, :to => :news_feed

  has_many :user_groups, dependent: :destroy
  has_many :members, through: :user_groups, class_name: 'User', source: :user, after_remove: :update_elasticsearch_member
  has_many :groups_polls
  has_many :polls, through: :groups_polls
  has_many :poll_responses, through: :polls, source: :responses
  has_many :events

  has_many :own_initiatives, class_name: 'Initiative', foreign_key: 'owner_group_id'
  has_many :initiative_participating_groups
  has_many :participating_initiatives, through: :initiative_participating_groups, source: :initiative

  has_many :budgets, as: :subject
  has_many :messages, class_name: 'GroupMessage'
  has_many :message_comments, through: :messages, class_name: 'GroupMessageComment', source: :comments
  has_many :news_links, dependent: :destroy
  has_many :news_link_comments, through: :news_links, class_name: 'NewsLinkComment', source: :comments
  has_many :social_links, dependent: :destroy
  has_many :invitation_segments_groups
  has_many :invitation_segments, class_name: 'Segment', through: :invitation_segments_groups
  has_many :resources, as: :container
  has_many :folders, as: :container
  has_many :folder_shares, as: :container
  has_many :shared_folders, through: :folder_shares, source: 'folder'
  has_many :campaigns_groups
  has_many :campaigns, through: :campaigns_groups
  has_many :questions, through: :campaigns
  has_many :answers, through: :questions
  has_many :answer_upvotes, through: :answers, source: :votes
  has_many :answer_comments, through: :answers, class_name: 'AnswerComment', source: :comments
  belongs_to :lead_manager, class_name: "User"
  belongs_to :owner, class_name: "User"
  has_many :outcomes
  has_many :pillars, through: :outcomes
  has_many :initiatives, through: :pillars
  has_many :updates, class_name: "GroupUpdate", dependent: :destroy

  has_many :fields, -> { where field_type: "regular"},
           as: :container,
           dependent: :destroy
  has_many :survey_fields, -> { where field_type: "group_survey"},
           class_name: 'Field',
           as: :container,
           dependent: :destroy

  has_many :group_leaders
  has_many :leaders, through: :group_leaders, source: :user

  has_many  :children, class_name: "Group", foreign_key: :parent_id
  belongs_to :parent, class_name: "Group", foreign_key: :parent_id
  belongs_to :group_category
  belongs_to :group_category_type

  has_attached_file :logo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_attachment_content_type :logo, content_type: %r{\Aimage\/.*\Z}

  has_attached_file :banner
  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

  has_attached_file :sponsor_media, s3_permissions: :private
  do_not_validate_attachment_file_type :sponsor_media

  validates :name, presence: true
  validates_format_of :contact_email, with: Devise.email_regexp, allow_blank: true

  validate :valid_yammer_group_link?

  before_create :build_default_news_feed
  before_save :send_invitation_emails, if: :send_invitations?
  before_save :create_yammer_group, if: :should_create_yammer_group?
  after_commit :update_all_elasticsearch_members
  before_validation :smart_add_url_protocol
  after_save :set_group_category_type_for_parent_if_sub_erg, on: [:create, :update]

  scope :top_participants,  -> (n) { order(total_weekly_points: :desc).limit(n) }
  # Active Record already has a defined a class method with the name private so we use is_private.
  scope :is_private,        -> {where(:private => true)}
  scope :non_private,       -> {where(:private => false)}
  # parents/children
  scope :all_parents,     -> {where(:parent_id => nil)}
  scope :all_children,    -> {where.not(:parent_id => nil)}

  accepts_nested_attributes_for :outcomes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :survey_fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :group_leaders, reject_if: :all_blank, allow_destroy: true


  def is_sub_group?
    return true if parent.present?
  end

  def is_parent_group?
    return true if parent.nil?
  end

  def capitalize_name
    name.split.map(&:capitalize).join(' ')
  end

  def set_default_group_contact
    group_leader = group_leaders.find_by(default_group_contact: true)&.user
    self.update(contact_email: group_leader&.email)
  end

  def managers
    leaders.to_a << owner
  end

  def news_feed
    if NewsFeed.where(:group_id => id).count > 0
      return NewsFeed.find_by_group_id(id)
    else
      feed = NewsFeed.new
      feed.group_id = id
      feed.save
      return feed
    end
  end

  def valid_yammer_group_link?
    if yammer_group_link.present? && !yammer_group_id
      errors.add(:yammer_group_link, 'this is not a yammer group link')
      return false
    end

    return true
  end

  def yammer_group_id
    return nil if yammer_group_link.nil?
    eq_sign_position = yammer_group_link.rindex('=')
    return nil if eq_sign_position.nil?

    group_id = yammer_group_link[(eq_sign_position+1)..yammer_group_link.length]

    group_id.to_i
  end

  def calendar_color
    self[:calendar_color] || enterprise.try(:theme).try(:primary_color) || 'cccccc'
  end

  def approved_budget
    (budgets.approved.map{ |b| b.requested_amount || 0 }).reduce(0, :+)
  end

  def available_budget
    return 0 unless annual_budget
    annual_budget - (approved_budget + spent_budget)
  end

  def spent_budget
    (initiatives.map{ |i| i.current_expences_sum || 0 } ).reduce(0, :+)
  end

  def active_members
    if pending_users.enabled?
      filter_by_membership(true).active
    else
      members.active
    end
  end

  def pending_members
    if pending_users.enabled?
      filter_by_membership(false).active
    else
      members.none
    end
  end

  def file_safe_name
    name.gsub!(/[^0-9A-Za-z.\-]/, '_')
  end

  def possible_participating_groups
    # return groups list without current group
    group_id = self.id
    self.enterprise.groups.select { |g| g.id != group_id }
  end

  def sync_yammer_users
    yammer = YammerClient.new(enterprise.yammer_token)

    # Subscribe users who are part of the ERG in Diverst to the Yammer group
    members.each do |user|
      yammer_user = yammer.user_with_email(user.email)
      next if yammer_user.nil? # Skip user if he/she isn't part of the Yammer network

      # Cache the user's yammer token if it's not
      if user.yammer_token.nil?
        yammer_user_token = yammer.token_for_user(user_id: yammer_user['id'])
        user.update(yammer_token: yammer_user_token['token'])
      end

      # Impersonate the user and subscribe to the group
      user_yammer = YammerClient.new(user.yammer_token)
      user_yammer.subscribe_to_group(yammer_id)
    end
  end

  def highcharts_history(field:, from: 1.year.ago, to: Time.current)
    self.updates
        .where('created_at >= ?', from)
        .where('created_at <= ?', to)
        .order(created_at: :asc)
        .map do |update|
      [
              update.created_at.to_i * 1000, # We multiply by 1000 to get milliseconds for highcharts
              update.info[field]
            ]
    end
  end

  #Users who enters group have accepted flag set to false
  #This sets flag to true
  def accept_user_to_group(user_id)
    user_group = user_groups.where(user_id: user_id).first
    return false if user_group.blank?

    user_group.update(accepted_member: true)
  end

  def survey_answers_csv
    CSV.generate do |csv|
      csv << ['user_id', 'user_email', 'user_first_name', 'user_last_name'].concat(survey_fields.map(&:title))

      user_groups.with_answered_survey.includes(:user).order(created_at: :desc).each do |user_group|
        user_group_row = [
          user_group.user.id,
          user_group.user.email,
          user_group.user.first_name,
          user_group.user.last_name
        ]

        survey_fields.each do |field|
          user_group_row << field.csv_value(user_group.info[field])
        end

        csv << user_group_row
      end
    end
  end

  def title_with_leftover_amount
    "Create event from #{name} leftover ($#{leftover_money})"
  end

  def pending_comments_count
    message_comments.unapproved.count + news_link_comments.unapproved.count + answer_comments.unapproved.count
  end

  def pending_posts_count
    news_links.unapproved.count + messages.unapproved.count + social_links.unapproved.count
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

  def set_group_category_type_for_parent_if_sub_erg
    if self.is_sub_group?
      self.parent.update(group_category_type_id: self.group_category_type_id) unless self.group_category_type_id.nil?
    end
  end

  def filter_by_membership(membership_status)
    members.references(:user_groups).where('user_groups.accepted_member=?', membership_status)
  end

  # Create the group in Yammer
  def create_yammer_group
    yammer = YammerClient.new(enterprise.yammer_token)
    group = yammer.create_group(
      name: name,
      description: description
    )

    unless group['id'].nil?
      update(yammer_group_created: true, yammer_id: group['id'])
      SyncYammerGroupJob.perform_later(self)
    end
  end

  def send_invitation_emails
    GroupMailer.delay.invitation(self, invitation_segments)
    self.send_invitations = false
    invitation_segments.clear
  end

  def should_create_yammer_group?
    yammer_create_group? &&
      !yammer_group_created &&
      !enterprise.yammer_token.nil?
  end

  # This method only exists because it's used in a callback
  def update_elasticsearch_member(member)
    member.__elasticsearch__.update_document
  end

  # Update members in elastic_search
  def update_all_elasticsearch_members
    members.includes(:poll_responses).each do |member|
      update_elasticsearch_member(member)
    end
  end

  def self.avg_members_per_group(enterprise:)
    group_sizes = UserGroup.where(group: enterprise.groups).group(:group).count.values
    return nil if group_sizes.length == 0
    group_sizes.sum / group_sizes.length
  end

  def build_default_news_feed
    build_news_feed
    true
  end
end
