class Group < BaseClass
  include PublicActivity::Common
  include CustomTextHelpers

  extend Enumerize

  enumerize :layout, default: :layout_0, in: [
    :layout_0,
    :layout_1,
    :layout_2
  ]

  enumerize :pending_users, default: :disabled, in: [
    :disabled,
    :enabled
  ]

  enumerize :members_visibility, default: :managers_only, in: [
    :global,
    :group,
    :managers_only
  ]

  enumerize :event_attendance_visibility, default: :managers_only, in: [
    :global,
    :group,
    :managers_only
  ]

  enumerize :messages_visibility, default: :managers_only, in: [
    :global,
    :group,
    :managers_only
  ]

  enumerize :latest_news_visibility, default: :leaders_only, in: [
    :public,
    :group,
    :leaders_only
  ]

  # :public and :non_member have their values defined in locales/en.yml
  enumerize :upcoming_events_visibility, default: :leaders_only, in: [
                                    :public,
                                    :group,
                                    :leaders_only,
                                    :non_member
                                  ]
  enumerize :unit_of_expiry_age, default: :months, in: [
    :weeks,
    :months,
    :years
  ]

  belongs_to :enterprise, counter_cache: true
  belongs_to :lead_manager, class_name: 'User'
  belongs_to :owner, class_name: 'User'

  has_one :news_feed, dependent: :destroy

  delegate :news_feed_links,        to: :news_feed
  delegate :shared_news_feed_links, to: :news_feed

  has_many :user_groups, dependent: :destroy
  has_many :members, through: :user_groups, class_name: 'User', source: :user
  has_many :accepted_members, -> { where(accepted_member: true).active }, class_name: 'UserGroup'
  has_many :groups_polls, dependent: :destroy
  has_many :polls, through: :groups_polls
  has_many :poll_responses, through: :polls, source: :responses

  has_many :own_initiatives, class_name: 'Initiative', foreign_key: 'owner_group_id', dependent: :destroy
  has_many :initiative_participating_groups
  has_many :participating_initiatives, through: :initiative_participating_groups, source: :initiative

  has_many :budgets, dependent: :destroy
  has_many :messages, class_name: 'GroupMessage', dependent: :destroy
  has_many :message_comments, through: :messages, class_name: 'GroupMessageComment', source: :comments
  has_many :news_links, dependent: :destroy
  has_many :news_link_comments, through: :news_links, class_name: 'NewsLinkComment', source: :comments
  has_many :social_links, dependent: :destroy
  has_many :invitation_segments_groups, dependent: :destroy
  has_many :invitation_segments, class_name: 'Segment', through: :invitation_segments_groups
  has_many :resources, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :folder_shares, dependent: :destroy
  has_many :shared_folders, through: :folder_shares, source: 'folder'
  has_many :campaigns_groups, dependent: :destroy
  has_many :campaigns, through: :campaigns_groups
  has_many :questions, through: :campaigns
  has_many :answers, through: :questions
  has_many :answer_upvotes, through: :answers, source: :votes
  has_many :answer_comments, through: :answers, class_name: 'AnswerComment', source: :comments
  belongs_to :lead_manager, class_name: 'User'
  belongs_to :owner, class_name: 'User'
  has_many :outcomes, dependent: :destroy
  has_many :pillars, through: :outcomes
  has_many :initiatives, through: :pillars
  has_many :updates, class_name: 'GroupUpdate', dependent: :destroy
  has_many :views, dependent: :destroy
  has_many :twitter_accounts, class_name: 'TwitterAccount', dependent: :destroy

  has_many :fields, -> { where field_type: 'regular' },
           dependent: :delete_all
  has_many :survey_fields, -> { where field_type: 'group_survey' },
           class_name: 'Field',
           dependent: :delete_all

  has_many :group_leaders, -> { order(position: :asc) }, dependent: :destroy
  has_many :leaders, through: :group_leaders, source: :user
  has_many :sponsors, dependent: :destroy

  has_many :children, class_name: 'Group', foreign_key: :parent_id, dependent: :destroy
  has_many :annual_budgets, dependent: :destroy

  belongs_to :parent, class_name: 'Group', foreign_key: :parent_id
  belongs_to :group_category
  belongs_to :group_category_type

  # re-add to allow migration file to run
  has_attached_file :sponsor_media, s3_permissions: :private
  do_not_validate_attachment_file_type :sponsor_media

  has_attached_file :logo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: ActionController::Base.helpers.image_path('/assets/missing.png'), s3_permissions: :private
  validates_length_of :event_attendance_visibility, maximum: 191
  validates_length_of :unit_of_expiry_age, maximum: 191
  validates_length_of :home_message, maximum: 65535
  validates_length_of :layout, maximum: 191
  validates_length_of :short_description, maximum: 65535
  validates_length_of :upcoming_events_visibility, maximum: 191
  validates_length_of :latest_news_visibility, maximum: 191
  validates_length_of :company_video_url, maximum: 191
  validates_length_of :sponsor_image_content_type, maximum: 191
  validates_length_of :sponsor_image_file_name, maximum: 191
  validates_length_of :calendar_color, maximum: 191
  validates_length_of :banner_content_type, maximum: 191
  validates_length_of :banner_file_name, maximum: 191
  validates_length_of :messages_visibility, maximum: 191
  validates_length_of :members_visibility, maximum: 191
  validates_length_of :pending_users, maximum: 191
  validates_length_of :yammer_group_link, maximum: 191
  validates_length_of :yammer_group_name, maximum: 191
  validates_length_of :logo_content_type, maximum: 191
  validates_length_of :logo_file_name, maximum: 191
  validates_length_of :description, maximum: 65535
  validates_length_of :name, maximum: 191
  validates_attachment_content_type :logo, content_type: %r{\Aimage\/.*\Z}

  has_attached_file :banner
  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/

  validates :name, presence: true, uniqueness: { scope: :enterprise_id }

  # only allow one default_mentor_group per enterprise
  validates_uniqueness_of :default_mentor_group, scope: [:enterprise_id], conditions: -> { where(default_mentor_group: true) }

  validate :valid_yammer_group_link?

  validate :ensure_one_level_nesting
  validate :ensure_not_own_parent
  validate :ensure_not_own_child

  before_save :send_invitation_emails, if: :send_invitations?
  before_save :create_yammer_group, if: :should_create_yammer_group?
  before_validation :smart_add_url_protocol
  after_create :create_news_feed
  after_update :accept_pending_members, unless: :pending_members_enabled?
  after_update :resolve_auto_archive_state, if: :no_expiry_age_set_and_auto_archive_true?

  attr_accessor :skip_label_consistency_check
  validate :perform_check_for_consistency_in_category, on: [:create, :update], unless: :skip_label_consistency_check
  validate :ensure_label_consistency_between_parent_and_sub_groups, on: [:create, :update]

  scope :by_enterprise, -> (e) { where(enterprise_id: e) }
  scope :top_participants,  -> (n) { order(total_weekly_points: :desc).limit(n) }
  # Active Record already has a defined a class method with the name private so we use is_private.
  scope :is_private,        -> { where(private: true) }
  scope :non_private,       -> { where(private: false) }
  # parents/children
  scope :all_parents,     -> { where(parent_id: nil) }
  scope :all_children,    -> { where.not(parent_id: nil) }

  accepts_nested_attributes_for :outcomes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :survey_fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :group_leaders, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :sponsors, reject_if: :all_blank, allow_destroy: true

  attr_accessor :start_date, :end_date

  def start_date
    self.annual_budgets.last.start_date if self.annual_budgets.last
  end

  def end_date
    self.annual_budgets.last.end_date if self.annual_budgets.last
  end

  def archive_switch
    if auto_archive?
      update(auto_archive: false)
    else
      update(auto_archive: true)
    end
  end

  def layout_values
    {
      'layout_0' => 'Default layout',
      'layout_1' => 'Layout without leader boards for Most Active Members',
      'layout_2' => "Layout with #{c_t(:sub_erg).pluralize} on top of group leaders"
    }
  end

  def is_parent_group?
    (parent.nil? && children.any?)
  end

  def is_sub_group?
    parent.present?
  end

  def total_views
    views.size
  end

  def is_standard_group?
    (parent.nil? && children.empty?)
  end

  def capitalize_name
    name.split.map(&:capitalize).join(' ')
  end

  def contact_email
    group_leader = group_leaders.find_by(default_group_contact: true)&.user
    group_leader&.email
  end

  def managers
    leaders.to_a << owner
  end

  def valid_yammer_group_link?
    if yammer_group_link.present? && !yammer_group_id
      errors.add(:yammer_group_link, 'this is not a yammer group link')
      return false
    end

    true
  end

  def yammer_group_id
    return nil if yammer_group_link.nil?

    eq_sign_position = yammer_group_link.rindex('=')
    return nil if eq_sign_position.nil?

    group_id = yammer_group_link[(eq_sign_position + 1)..yammer_group_link.length]

    group_id.to_i
  end

  def calendar_color
    self[:calendar_color] || enterprise.try(:theme).try(:primary_color) || 'cccccc'
  end

  def approved_budget
    annual_budget = annual_budgets.find_by(closed: false)
    return 0 if annual_budget.nil?

    (budgets.where(annual_budget_id: annual_budget.id).approved.map { |b| b.requested_amount || 0 }).reduce(0, :+)
  end

  def available_budget
    approved_budget - spent_budget
  end

  def spent_budget
    annual_budget = annual_budgets.find_by(closed: false)
    return 0 if annual_budget.nil?

    (initiatives.where(annual_budget_id: annual_budget.id).map { |i| i.current_expences_sum || 0 }).reduce(0, :+)
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

  # Necessary for the `unless` in the `after_save :accept_pending_members` callback
  def pending_members_enabled?
    pending_users.enabled?
  end

  def logo_expiring_thumb
    return nil if logo.blank?

    logo.expiring_url(30, :thumb)
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

  # Users who enters group have accepted flag set to false
  # This sets flag to true
  def accept_user_to_group(user_id)
    user_group = user_groups.find_by(user_id: user_id)
    return false if user_group.blank?

    user_group.update(accepted_member: true)
  end

  def survey_answers_csv
    CSV.generate do |csv|
      csv << %w(user_id user_email user_first_name user_last_name).concat(survey_fields.map(&:title))

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

  def membership_list_csv(group_members)
    total_nb_of_members = group_members.count
    mentorship_module_enabled = enterprise.mentorship_module_enabled?
    fields = enterprise.fields.where(add_to_member_list: true)
    fields.map(&:title)

    CSV.generate do |csv|
      first_row = %w(first_name last_name email_address)
      first_row += %w(mentor mentee) if mentorship_module_enabled
      first_row += fields.map(&:title)

      csv << first_row

      group_members.each do |member|
        membership_list_row = []
        membership_list_row += [ member.first_name, member.last_name, member.email ]
        membership_list_row += [ member.mentor, member.mentee ] if mentorship_module_enabled

        member_info = member.info
        membership_list_row += fields.map { |fld| fld.to_string(member_info.fetch(fld.id)) rescue nil }

        csv << membership_list_row
      end

      csv << ['total', nil, "#{total_nb_of_members}"]
    end
  end

  def budgets_csv
    CSV.generate do |csv|
      csv << ['Requested amount', 'Available amount', 'Status', 'Requested at', '# of events', 'Description']
      self.budgets.order(created_at: :desc).each do |budget|
        csv << [budget.requested_amount, budget.available_amount, budget.status_title, budget.created_at, budget.budget_items.count, budget.description]
      end
    end
  end

  def field_time_series_csv(field_id)
    from = Time.at(params[:from] / 1000) rescue nil
    to = Time.at(params[:to] / 1000) rescue nil
    data = self.highcharts_history(
      field: Field.find(field_id),
      from: from || 1.year.ago,
      to: to || Time.current + 1.day
    )

    strategy = Reports::GraphTimeseriesGeneric.new(
      data: data
    )
    report = Reports::Generator.new(strategy)

    report.to_csv
  end

  def title_with_leftover_amount
    if annual_budget == leftover_money
      "Create event from #{name} ($#{available_budget})"
    else
      "Create event from #{name} leftover ($#{leftover_money == 0 ? 0.0 : available_budget})"
    end
  end

  def pending_comments_count
    message_comments.unapproved.count + news_link_comments.unapproved.count + answer_comments.unapproved.count
  end

  def pending_posts_count
    news_links.unapproved.count + messages.unapproved.count + social_links.unapproved.count
  end

  def accept_pending_members
    self.user_groups.update_all(accepted_member: true)
  end

  def has_survey?
    survey_fields.count > 0
  end

  def filtered_member_list(params)
    segments = (params['users_segments_segment_id_in'] || []).map do |seg_id|
      Segment.find(seg_id.to_i) if seg_id.present?
    end
    segments.select! { |seg| seg.present? }

    from = params['user_groups_created_at_gteq']
    to = params['user_groups_created_at_lteq']

    users = User.joins(:user_groups)
    users = users.joins(:users_segments) if segments.present?

    users = users
              .where('`user_groups`.`group_id` = ?', id)
              .where('`user_groups`.`accepted_member` = 1')
              .where('`users`.`active` = 1')

    users = users.where('`users_segments`.`segment_id` IN (?)', segments) if segments.present?
    users = users.where('`user_groups`.`created_at` >= ?', from) if from.present?
    users = users.where('`user_groups`.`created_at` <= ?', to) if to.present?
    users.distinct
  end

  def upcoming_events_slack_block
    upcoming_events = initiatives.upcoming.limit(5) + participating_initiatives.upcoming.limit(3)
    init_block = [
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "*#{name}*"
        }
      },
      {
        type: 'divider'
      }
    ]
    blocks = upcoming_events.reduce(init_block) { |sum, event| sum + event.to_slack_block + [{ type: 'divider' }] }
    pk, _ = enterprise.get_colours
    {
      attachments: [
        {
          fallback: "Events for #{name}",
          color: pk,
          blocks: blocks
        }
      ]
    }
  end

  def send_slack_webhook_message(message)
    if slack_webhook.present?
      SlackClient.post_web_hook_message(slack_webhook, message)
    end
  end

  def uninstall_slack
    SlackClient.uninstall(slack_auth_data)
    self.update(
          slack_auth_data: nil,
          slack_webhook: nil
        )
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

  def resolve_auto_archive_state
    update(auto_archive: false)
  end

  def no_expiry_age_set_and_auto_archive_true?
    return true if auto_archive? && (expiry_age_for_news == 0) && (expiry_age_for_events == 0) && (expiry_age_for_resources == 0)
  end

  def ensure_one_level_nesting
    if parent.present? && children.present?
      errors.add(:parent_id, "Group can't have both parent and children")
    end
  end

  def ensure_not_own_parent
    if parent.present? && parent.id == self.id
      errors.add(:parent_id, 'Group cant be its own parent')
    end
  end

  def ensure_not_own_child
    if children.exists?(self)
      errors.add(:child_ids, 'Group cant be its own child')
    end
  end

  def perform_check_for_consistency_in_category
    if self.parent.present?
      group_category_type = self.group_category.group_category_type if self.group_category
      if self.group_category && self.parent.group_category_type
        if group_category_type != self.parent.group_category_type
          errors.add(:group_category, "wrong label for #{self.parent.group_category_type.name}")
        end
      end
    end
  end

  def ensure_label_consistency_between_parent_and_sub_groups
    unless group_category.nil?
      if if_any_sub_group_category_type_not_equal_to_parent_category_type?
        errors.add(:group_category_id, 'chosen label inconsistent with labels of sub groups')
      end
    end
  end

  def if_any_sub_group_category_type_not_equal_to_parent_category_type?
    children.any? do |sub_group|
      unless sub_group.group_category_type.nil?
        sub_group.group_category_type&.name != group_category_type.name
      end
    end
  end

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
      SyncYammerGroupJob.perform_later(self.id)
    end
  end

  def should_create_yammer_group?
    yammer_create_group? &&
      !yammer_group_created &&
      !enterprise.yammer_token.nil?
  end

  def self.avg_members_per_group(enterprise:)
    group_sizes = UserGroup.where(group: enterprise.groups).group(:group).count.values
    return nil if group_sizes.length == 0

    group_sizes.sum / group_sizes.length
  end
end
