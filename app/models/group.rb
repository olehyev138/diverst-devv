class Group < ApplicationRecord
  include PublicActivity::Common
  include CustomTextHelpers
  include Group::Actions
  include DefinesFields
  extend Enumerize
  BUDGET_DELEGATE_OPTIONS = { to: :current_annual_budget, allow_nil: true, prefix: 'annual_budget' }

  @@field_users = [:user_groups, :updates]
  mattr_reader :field_users

  attr_accessor :skip_label_consistency_check

  enumerize :layout, default: :layout_0, in: [
    :layout_0,
    :layout_1,
    :layout_2
  ]

  enumerize :pending_users, default: :disabled, in: [
    :disabled,
    :enabled
  ]

  enumerize :members_visibility, default: :leaders_only, in: [
    :public,
    :group,
    :leaders_only
  ]

  enumerize :event_attendance_visibility, default: :leaders_only, in: [
    :public,
    :group,
    :leaders_only
  ]

  enumerize :messages_visibility, default: :leaders_only, in: [
    :public,
    :group,
    :leaders_only
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

  belongs_to :group_category
  belongs_to :group_category_type

  belongs_to :parent, class_name: 'Group', foreign_key: :parent_id, inverse_of: :children
  has_many :children, class_name: 'Group', foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  has_one :news_feed, dependent: :destroy

  has_many :messages, class_name: 'GroupMessage', dependent: :destroy
  has_many :message_comments, through: :messages, class_name: 'GroupMessageComment', source: :comments
  has_many :news_links, dependent: :destroy
  has_many :news_link_comments, through: :news_links, class_name: 'NewsLinkComment', source: :comments
  has_many :social_links, dependent: :destroy

  has_many :user_groups, dependent: :destroy
  has_many :members, through: :user_groups, class_name: 'User', source: :user

  has_many :groups_polls, dependent: :destroy
  has_many :polls, through: :groups_polls
  has_many :poll_responses, through: :polls, source: :responses

  has_many :own_initiatives, class_name: 'Initiative', foreign_key: 'owner_group_id', dependent: :destroy
  has_many :initiative_participating_groups
  has_many :participating_initiatives, through: :initiative_participating_groups, source: :initiative

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

  has_many :outcomes, dependent: :destroy
  has_many :pillars, through: :outcomes
  has_many :initiatives, through: :pillars

  has_many :group_leaders, -> { order(position: :asc) }, dependent: :destroy
  has_many :leaders, through: :group_leaders, source: :user

  has_many :annual_budgets, dependent: :destroy
  has_many :budgets, dependent: :destroy, through: :annual_budgets
  has_many :budget_items, dependent: :destroy, through: :budgets
  has_many :initiative_expenses, through: :annual_budgets

  has_many :fields, -> { where field_type: 'regular' },
           as: :field_definer,
           dependent: :destroy,
           after_add: :add_missing_field_background_job
  has_many :survey_fields, -> { where field_type: 'group_survey' },
           as: :field_definer,
           class_name: 'Field',
           dependent: :destroy,
           after_add: :add_missing_field_background_job
  has_many :updates, as: :updatable, dependent: :destroy

  has_many :views, dependent: :destroy
  has_many :twitter_accounts, class_name: 'TwitterAccount', dependent: :destroy
  has_many :sponsors, as: :sponsorable, dependent: :destroy

  # ActiveStorage
  has_one_attached :logo
  validates :logo, content_type: AttachmentHelper.common_image_types
  has_one_attached :banner
  validates :banner, content_type: AttachmentHelper.common_image_types
  has_one_attached :sponsor_media

  # TODO Remove after Paperclip to ActiveStorage migration
  has_attached_file :logo_paperclip, s3_permissions: 'private'
  has_attached_file :banner_paperclip
  has_attached_file :sponsor_media_paperclip, s3_permissions: 'private'
  has_attached_file :sponsor_image_paperclip, s3_permissions: 'private'

  delegate :news_feed_links,        to: :news_feed
  delegate :shared_news_feed_links, to: :news_feed

  delegate :leftover, BUDGET_DELEGATE_OPTIONS
  delegate :remaining, BUDGET_DELEGATE_OPTIONS
  delegate :approved, BUDGET_DELEGATE_OPTIONS
  delegate :expenses, BUDGET_DELEGATE_OPTIONS
  delegate :available, BUDGET_DELEGATE_OPTIONS
  delegate :finalized_expenditure, BUDGET_DELEGATE_OPTIONS
  delegate :carryover!, BUDGET_DELEGATE_OPTIONS
  delegate :reset!, BUDGET_DELEGATE_OPTIONS
  delegate :currency, BUDGET_DELEGATE_OPTIONS

  validates_length_of :event_attendance_visibility, maximum: 191
  validates_length_of :unit_of_expiry_age, maximum: 191
  validates_length_of :home_message, maximum: 65535
  validates_length_of :layout, maximum: 191
  validates_length_of :short_description, maximum: 65535
  validates_length_of :upcoming_events_visibility, maximum: 191
  validates_length_of :latest_news_visibility, maximum: 191
  validates_length_of :company_video_url, maximum: 191
  validates_length_of :calendar_color, maximum: 191
  validates_length_of :messages_visibility, maximum: 191
  validates_length_of :members_visibility, maximum: 191
  validates_length_of :pending_users, maximum: 191
  validates_length_of :yammer_group_link, maximum: 191
  validates_length_of :yammer_group_name, maximum: 191
  validates_length_of :description, maximum: 65535
  validates_length_of :name, maximum: 191

  # only allow one default_mentor_group per enterprise
  validates_uniqueness_of :default_mentor_group, scope: [:enterprise_id], conditions: -> { where(default_mentor_group: true) }

  validates :name, presence: true, uniqueness: { scope: :enterprise_id }
  validates :calendar_color, format: { with: %r{\A(?:[0-9a-fA-F]{3}){1,2}\z}, allow_blank: true, message: 'should be a valid hex color' }
  validates :expiry_age_for_news, numericality: { greater_than_or_equal_to: 0 }
  validates :expiry_age_for_events, numericality: { greater_than_or_equal_to: 0 }
  validates :expiry_age_for_resources, numericality: { greater_than_or_equal_to: 0 }

  validate :valid_yammer_group_link?
  validate :ensure_one_level_nesting
  validate :ensure_not_own_parent
  validate :ensure_not_own_child
  validate :perform_check_for_consistency_in_category, on: [:create, :update], unless: :skip_label_consistency_check
  validate :ensure_label_consistency_between_parent_and_sub_groups, on: [:create, :update]

  before_validation -> (group) { group.calendar_color = group.calendar_color.presence&.gsub('#', '') }

  before_save :send_invitation_emails, if: :send_invitations?
  before_save :create_yammer_group, if: :should_create_yammer_group?
  before_validation :smart_add_url_protocol
  after_create :create_news_feed
  after_create :set_position

  after_update :accept_pending_members, unless: :pending_members_enabled?
  after_update :resolve_auto_archive_state, if: :no_expiry_age_set_and_auto_archive_true?

  scope :by_enterprise, -> (e) { where(enterprise_id: e) }
  scope :top_participants, -> (n) { order(total_weekly_points: :desc).limit(n) }
  scope :joined_groups, -> (u) { joins(:user_groups).where(user_groups: { user_id: u }) }

  # Active Record already has a defined a class method with the name private so we use is_private.
  scope :is_private,        -> { where(private: true) }
  scope :non_private,       -> { where(private: false) }

  # parents/children
  scope :all_parents,     -> { where(parent_id: nil) }
  scope :all_children,    -> { where.not(parent_id: nil) }
  scope :no_children, -> { includes(:children).where(children_groups: { id: nil }) }

  # This scope acts as an alternative to `all_parents` which ignore a given list of groups, while getting the
  # children of said groups and adding them to the result of the query
  scope :replace_with_children, -> (*args) { where.not(id: args).where(parent_id: [nil] + args) }

  accepts_nested_attributes_for :outcomes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :survey_fields, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :group_leaders, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :sponsors, reject_if: :all_blank, allow_destroy: true

  def create_annual_budget
    AnnualBudget.create(group: self, closed: false)
  end

  def current_annual_budget
    if annual_budgets.loaded?
      @current_annual_budget ||= annual_budgets.find { |ab| ab.closed == false }
    else
      @current_annual_budget ||= annual_budgets.where(closed: false).last
    end
  end

  def current_annual_budget!
    current_annual_budget || create_annual_budget
  end

  def current_annual_budget=(annual_budget)
    annual_budgets.update_all(closed: true)
    annual_budget.update_attributes(closed: true, group_id: id)
  end

  def current_budget_items
    current_annual_budget&.budget_items || BudgetItem.none
  end

  def reload
    @current_annual_budget = nil
    super
  end

  def annual_budget
    current_annual_budget!.amount
  end

  def annual_budget=(new_budget)
    ab = current_annual_budget!
    ab&.amount = new_budget
    ab&.save
  end

  def self.load_sums
    select(
        'groups.*,'\
        ' Sum(coalesce(`initiative_expenses`.`amount`, 0)) as `expenses_sum`,'\
        ' Sum(CASE WHEN `budgets`.`is_approved` = TRUE THEN coalesce(`budget_items`.`estimated_amount`, 0) ELSE 0 END) as `approved_sum`,'\
        ' Sum(coalesce(`initiatives`.`estimated_funding`, 0)) as `reserved_sum`')
        .left_joins(:initiative_expenses)
        .group(Group.column_names).each do |g|
      g.current_annual_budget.instance_variable_set(:@expenses, g.expenses_sum)
      g.current_annual_budget.instance_variable_set(:@approved, g.approved_sum)
      g.current_annual_budget.instance_variable_set(:@reserved, g.reserved_sum)
    end
  end

  def logo_location(expires_in: 3600, default_style: :medium)
    return nil unless logo.attached?

    # default_style = :medium if !logo.styles.keys.include? default_style
    # logo.expiring_url(expires_in, default_style)
    Rails.application.routes.url_helpers.url_for(logo)
  end

  def banner_location
    return nil unless banner.attached?

    # banner.expiring_url(36000)
    Rails.application.routes.url_helpers.url_for(banner)
  end

  def resolve_auto_archive_state
    update(auto_archive: false)
  end

  def no_expiry_age_set_and_auto_archive_true?
    true if auto_archive? && (expiry_age_for_news == 0) && (expiry_age_for_events == 0) && (expiry_age_for_resources == 0)
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

  def get_calendar_color
    self[:calendar_color].presence || enterprise.try(:theme).try(:primary_color) || 'cccccc'
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

  def file_safe_name
    name.gsub(/[^0-9A-Za-z.\-]/, '_')
  end

  def logo_expiring_thumb
    # TODO
    # return nil if logo.blank?
    # logo.expiring_url(30, :thumb)
  end

  def possible_participating_groups
    # return groups list without current group
    group_id = self.id
    self.enterprise.groups.to_a.select { |g| g.id != group_id }
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
        update[field]
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
          user_group_row << field.csv_value(user_group[field])
        end

        csv << user_group_row
      end
    end
  end

  def membership_list_csv(group_members)
    total_nb_of_members = group_members.count
    mentorship_module_enabled = enterprise.mentorship_module_enabled?

    CSV.generate do |csv|
      first_row = %w(first_name last_name email_address)
      first_row += %w(mentor mentee) if mentorship_module_enabled

      csv << first_row

      group_members.each do |member|
        membership_list_row = []
        membership_list_row += [ member.first_name, member.last_name, member.email ]
        membership_list_row += [ member.mentor, member.mentee ] if mentorship_module_enabled

        member_info = member.info

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
    if annual_budget_expenses > 0
      "Create event from #{name} ($#{annual_budget_available})"
    else
      "Create event from #{name} leftover ($%.2f)" % (annual_budget_remaining == 0 ? 0 : annual_budget_available).round(2)
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

  protected

  def smart_add_url_protocol
    return nil if company_video_url.blank?

    self.company_video_url = "http://#{company_video_url}" unless have_protocol?
  end

  def have_protocol?
    company_video_url[%r{\Ahttp:\/\/}] || company_video_url[%r{\Ahttps:\/\/}]
  end

  private

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
    if children.exists?(self.id)
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

  def set_position
    self.position = self.id
  end
end
