class NewsFeedLink < ActiveRecord::Base
  belongs_to :news_feed
  has_many :share_links, dependent: :destroy
  has_many :shared_news_feeds, through: :share_links, source: :news_feed
  belongs_to :link, :polymorphic => true

  has_many :news_feed_link_segments
  has_many :likes, dependent: :destroy
  has_many :views, dependent: :destroy

  delegate :group,    :to => :news_feed
  delegate :segment,  :to => :news_feed_link_segment, :allow_nil => true

  validates :news_feed_id,    presence: true
  validates :link_type,       presence: true

  before_save :check_link
  after_create :approve_link

  scope :approved,     -> {
    joins('LEFT OUTER JOIN share_links on share_links.news_feed_link_id = news_feed_links.id').
      where('news_feed_links.approved = true AND (share_links.approved = true OR share_links.approved is NULL)')
      .uniq
  }

  scope :not_approved,     -> {
    joins('LEFT OUTER JOIN share_links on share_links.news_feed_link_id = news_feed_links.id').
      where('news_feed_links.approved = false OR share_links.approved = false')
      .uniq
  }

  # Create array out of both associations, map it to ids and then where to generate a ActiveRecord::Relation
  scope :links, -> (group) {
    where(id: (group.news_feed_links + group.shared_news_feed_links).map(&:id))
      .includes(:link, :news_feed)
  }

  scope :approved_links,      -> (group) { links(group).approved }
  scope :unapproved_links,    -> (group) { links(group).not_approved }

  scope :news_feed_order, -> { order(is_pinned: :desc, created_at: :desc) }
  scope :segments, -> (user) {
    joins('LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id')
    .where('news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)', user.segments.pluck(:id))
  }

  scope :leader_links_count,    -> (group) { approved_links(group).count }
  scope :user_links_count,      -> (group, user) { approved_links(group).segments(user).count }
  scope :leader_links,          -> (group, limit) { approved_links(group).news_feed_order.limit(limit) }
  scope :user_links,            -> (group, user, limit) { approved_links(group).segments(user).news_feed_order.limit(limit) }

  def approved?(group)
    return self.approved if share_links.empty?
    approved && share_links.find_by(news_feed: group.news_feed.id).approved
  end


  # View Count methods
  def increment_view(user)
    view = views.find_or_create_by(user_id: user.id) do |v|
      v.enterprise_id = user.enterprise_id
    end

    view.view_count += 1
    view.save
  end

  def total_views
    views.sum(:view_count)
  end

  def unique_views
    views.all.count
  end

  private

  # Validates that link is present
  # Cant use normal validation since NewsFeedLink is saved first
  def check_link
    unless link
      errors[:link] = 'cant be blank'
      false
    end
  end

  # checks if link can automatically be approved
  # links are automatically approved if author is a
  # group leader
  def approve_link
    if GroupPolicy.new(link.author, link.group).erg_leader_permissions?
      self.approved = true
      self.save!
    end
  end
end
