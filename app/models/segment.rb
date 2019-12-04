class Segment < ApplicationRecord
  extend Enumerize
  include PublicActivity::Common
  include Segment::Actions

  enumerize :active_users_filter, default: :both_active_and_inactive, in: [
    :both_active_and_inactive,
    :only_active,
    :only_inactive
  ]

  enumerize :job_status, in: {
    inactive: 0,
    active: 1
  }

  belongs_to :parent, class_name: 'Segment', foreign_key: :parent_id
  has_many :children, class_name: 'Segment', foreign_key: :parent_id, dependent: :destroy

  belongs_to :enterprise
  belongs_to :owner, class_name: 'User'

  # Rules
  has_many :field_rules, class_name: 'SegmentFieldRule', dependent: :destroy
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

  validates_length_of :active_users_filter, maximum: 191
  validates_length_of :name, maximum: 191
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

  scope :all_parents,     -> { where(parent_id: nil) }
  scope :all_children,    -> { where.not(parent_id: nil) }

  def ordered_members
    order_rules.reduce(members) { |members, rule| members.order(rule.field_name => rule.operator_name) }
  end

  def rules
    field_rules
  end

  def all_rules_count
    field_rules.size + order_rules.size + group_rules.size
  end

  def general_rules_followed_by?(user)
    case active_users_filter
    when 'only_active'
      user.active?
    when 'only_inactive'
      !user.active?
    else
      true
    end
  end

  def cache_segment_members
    CacheSegmentMembersJob.perform_later self.id
  end

  def self.update_all_members
    Segment.all.find_each do |segment|
      segment.job_status = 1
      segment.save!
      CacheSegmentMembersJob.perform_later segment.id
    end
  end

  # Rule methods

  def apply_field_rules(users)
    users.select do |user|
      follows_rules = true

      field_rules.each do |rule|
        unless rule.followed_by?(user)
          follows_rules = false
          break
        end
      end

      follows_rules
    end
  end

  def apply_group_rules(users)
    self.group_rules.reduce(users) do |filtered_users, rule|
      rule.apply(filtered_users)
    end
  end

  def apply_order_rules(users)
    # Apply order rules only if limit present
    # Order would have no effect on the segment population if limit was not present
    #   1) Order will not be saved into the database, ie segment.members cannot be serialized with order
    #   2) Order here to change the dataset which will only happen with a limit
    #      - ie ordering on sign_in_count and limiting by 50, effects the segments total member population

    return users if self.limit.blank?

    # Ordering requires an ActiveRecord collection, users is passed as an array of User objects
    users = enterprise.users.where('id in (?)', users.map(&:id))

    # Apply each order rule to the users list
    self.order_rules.reduce(users) { |ordered_users, rule| ordered_users.order(rule.field_name => rule.operator_name) }
  end


  # TODO: deal with activerecord vs array nonsense - as field_rule application returns array now

  # central method to build segment with new/updated rules
  def update_members
    old_members = self.members.all
    new_members = self.enterprise.users.all

    # start with entire user dataset & reduce by applying rules in the following order:
    #  - field rules
    #  - group rules
    #  - order rules
    #  - limit
    new_members = apply_field_rules(new_members)
    new_members = apply_group_rules(new_members)
    new_members = apply_order_rules(new_members)
    new_members = new_members.take(self.limit) if self.limit.present?

    # Compare new dataset to old
    # members to remove - members that were in old & not in new
    # members to add - members that are in new but not in old
    members_to_remove = old_members - new_members
    members_to_add = new_members - old_members

    # First delete old members
    members_to_remove.each do |member|
      self.members.delete(member)
    end

    # Lastly add new members
    members_to_add.each do |member|
      self.members << member unless self.members.where(id: member.id).exists?
      begin
        # Update user in Elasticsearch to reflect segment (user_segment) membership
        member.__elasticsearch__.update_document
      rescue
        next
      end
    end
  end
end
