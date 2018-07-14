class NewsFeedLink < ActiveRecord::Base
  has_many :share_links, dependent: :destroy
  has_many :news_feeds, through: :share_links, source: :news_feed

  belongs_to :link, :polymorphic => true

  has_many :news_feed_link_segments
  has_many :likes, dependent: :destroy
  has_many :views, dependent: :destroy

  delegate :segment,  :to => :news_feed_link_segment, :allow_nil => true

  validates :news_feed_id,    presence: true
  validates :link_type,       presence: true

  before_create :set_share_link
  before_save :check_link
  after_create :approve_link

  scope :approved,     -> (group) {
    joins(:share_links)
      .where('share_links.news_feed_id = (?)', group.news_feed.id)
      .where('share_links.approved = true')
  }

  scope :unapproved,   -> (group) {
    joins(:share_links)
      .where('share_links.news_feed_id = (?)', group.news_feed.id)
      .where('share_links.approved = false')
  }

  scope :common_includes, -> { includes(:link) }

  scope :news_feed_order, -> (group) {
    joins(:share_links)
      .where('share_links.news_feed_id = (?)', group.news_feed.id)
    .order('share_links.is_pinned DESC', created_at: :desc)
  }

  scope :segments, -> (user) {
    joins('LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id')
    .where('news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (?)', user.segments.pluck(:id))
  }

  scope :leader_links,          -> (group, limit) { common_includes.approved(group).news_feed_order(group).limit(limit) }
  scope :user_links,            -> (group, user, limit) { common_includes.approved(group).segments(user).news_feed_order(group).limit(limit) }

  def news_feed(group)
    news_feeds.find(group.news_feed.id)
  end

  def share_link(group)
    share_links.find_by(news_feed: group.news_feed.id)
  end

  def posted_by_group
    link.group
  end

  def shared?(group)
    link.group_id != group.id
  end

  def is_shared?
    share_links.count > 1
  end

  def approved?(group)
    share_link(group).approved
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

  def pin(group)
    share_link = share_link(group)
    share_link.is_pinned = true
    share_link.save!
  end

  def unpin(group)
    share_link = share_link(group)
    share_link.is_pinned = false
    share_link.save!
  end

  def is_pinned?(group)
    share_link(group).is_pinned?
  end

  private

  # Callbacks

  def set_share_link
    share_links << ShareLink.new(news_feed_link_id: self.id, news_feed_id: link.group.news_feed.id)
  end

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
    share_links.each do |share_link|
      if GroupPolicy.new(link.author, share_link.group).erg_leader_permissions?
        share_link.approved = true
        share_link.save
      end
    end
  end
end
