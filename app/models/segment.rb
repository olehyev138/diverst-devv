class Segment < BaseClass
  extend Enumerize
  include PublicActivity::Common

  enumerize :active_users_filter, default: :both_active_and_inactive, in: [
    :both_active_and_inactive,
    :only_active,
    :only_inactive
  ]

  enumerize :job_status, in: {
    inactive: 0,
    active: 1
  }

  belongs_to :parent, class_name: "Segment", foreign_key: :parent_id
  has_many :children, class_name: "Segment", foreign_key: :parent_id, dependent: :destroy

  belongs_to :enterprise
  belongs_to :owner, class_name: "User"

  # Rules
  has_many :field_rules, class_name: 'SegmentRule', dependent: :destroy
  has_many :order_rules, class_name: 'SegmentOrderRule', dependent: :destroy
  has_many :group_rules, class_name: 'SegmentGroupScopeRule', dependent: :destroy

  has_many :users_segments, dependent: :destroy
  has_many :polls_segments, dependent: :destroy
  has_many :polls, through: :polls_segments
  has_many :group_messages_segments, dependent: :destroy
  has_many :group_messages, through: :group_messages_segments
  has_many :invitation_segments_groups, dependent: :destroy
  has_many :groups, inverse_of: :invitation_segments, through: :invitation_segments_groups
  has_many :initiative_segments, dependent: :destroy
  has_many :initiatives, through: :initiative_segments

  has_many :members, class_name: 'User', through: :users_segments, source: :user, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :active_users_filter
  validates :name, uniqueness: { scope: :enterprise_id }

  before_save { self.job_status = 1 }
  after_commit :cache_segment_members, on: [:create, :update]

  validates_presence_of :enterprise

  # Rule attributes
  accepts_nested_attributes_for :field_rules, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :order_rules, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :group_rules, reject_if: :all_blank, allow_destroy: true

  scope :all_parents,     -> {where(:parent_id => nil)}
  scope :all_children,    -> {where.not(:parent_id => nil)}

  def ordered_members
    order_rules.reduce(members) { |members, rule| members.order(rule.field_name => rule.operator_name) }
  end

  def rules
    field_rules
  end

  def all_rules
    field_rules + order_rules + group_rules
  end

  def general_rules_followed_by?(user)
    case active_users_filter
    when 'only_active'
      return user.active?
    when 'only_inactive'
      return !user.active?
    else
      return true
    end
  end

  def cache_segment_members
    self.job_status = 1
    CacheSegmentMembersJob.perform_later self.id
  end

  def self.update_all_members
    Segment.all.find_each do |segment|
      segment.job_status = 1
      CacheSegmentMembersJob.perform_later segment.id
    end
  end
end
