class GroupMessage < ApplicationRecord
  include PublicActivity::Common
  has_many :group_messages_segments, dependent: :destroy

  has_many :segments, through: :group_messages_segments, before_remove: :remove_segment_association
  has_many :comments, class_name: 'GroupMessageComment', foreign_key: :message_id, dependent: :destroy
  has_many :user_reward_actions

  belongs_to :owner, class_name: 'User', counter_cache: :own_messages_count
  belongs_to :group

  has_one :news_feed_link
  has_many :news_tags, through: :news_feed_link

  after_create :approve_link
  after_create :build_default_link
  after_create :post_new_message_to_slack, unless: Proc.new { Rails.env.test? }

  accepts_nested_attributes_for :news_feed_link, allow_destroy: true

  delegate :increment_view, to: :news_feed_link
  delegate :total_views, to: :news_feed_link
  delegate :unique_views, to: :news_feed_link

  validates_length_of :content, maximum: 65535
  validates_length_of :subject, maximum: 191
  validates :group_id,    presence: true
  validates :subject,     presence: true
  validates :content,     presence: true
  validates :owner_id,    presence: true

  alias_attribute :author, :owner

  after_destroy :remove_news_feed_link

  after_destroy :remove_news_feed_link

  scope :of_segments, ->(segment_ids) {
    gm_condtions = ['group_messages_segments.segment_id IS NULL']
    gm_condtions << "group_messages_segments.segment_id IN (#{ segment_ids.join(",") })" unless segment_ids.empty?
    joins('LEFT JOIN group_messages_segments ON group_messages_segments.group_message_id = group_messages.id')
      .where(gm_condtions.join(' OR '))
  }

  scope :unapproved, -> { joins(:news_feed_link).where(news_feed_links: { approved: false }) }
  scope :approved, -> { joins(:news_feed_link).where(news_feed_links: { approved: true }) }

  settings do
    mappings dynamic: false do
      indexes :created_at, type: :date
      indexes :group_id, type: :integer
      indexes :group do
        indexes :enterprise_id, type: :integer
        indexes :parent_id, type: :integer
        indexes :name, type: :keyword
        indexes :parent do
          indexes :name, type: :keyword
        end
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [:created_at, :group_id],
        include: { group: {
          only: [:enterprise_id, :parent_id, :name],
          include: { parent: { only: [:name] } }
        } }
      )
    ).merge({ 'created_at' => self.created_at.beginning_of_hour })
  end

  def approve_link
    return if news_feed_link.nil?

    news_feed_link.approve_link
  end

  def comments_count
    if group.enterprise.enable_pending_comments?
      comments.approved.count
    else
      comments.count
    end
  end

  def users
    if segments.empty?
      group.members
    else
      User
        .joins(:groups, :segments)
        .where(
          'groups.id' => group.id,
          'segments.id' => segments.ids
        )
    end
  end

  def owner_name
    return 'Unknown' if owner.blank?

    owner.first_name + owner.last_name
  end

  # call back to delete news link segment associations
  def remove_segment_association(segment)
    group_messages_segment = self.group_messages_segments.find_by(segment_id: segment.id)
    group_messages_segment.news_feed_link_segment.destroy
  end

  private

  def build_default_link
    return if news_feed_link.present?

    create_news_feed_link(news_feed_id: group.news_feed.id)
  end

  def remove_news_feed_link
    news_feed_link.destroy if news_feed_link.present?
  end
end
