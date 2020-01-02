class NewsFeedLink < ApplicationRecord
  include PublicActivity::Common
  include NewsFeedLink::Actions

  belongs_to :news_feed
  belongs_to :group_message, dependent: :delete
  belongs_to :news_link, dependent: :delete
  belongs_to :social_link, dependent: :delete

  has_many :news_feed_link_segments, dependent: :destroy
  has_many :segments, through: :news_feed_link_segments
  has_many :shared_news_feed_links, class_name: 'SharedNewsFeedLink', source: :news_feed_link, dependent: :destroy
  has_many :shared_news_feeds, through: :shared_news_feed_links, source: :news_feed

  has_many :likes, dependent: :destroy
  has_many :views, dependent: :destroy

  delegate :group,    to: :news_feed
  delegate :segment,  to: :news_feed_link_segment, allow_nil: true

  scope :approved, -> { where(approved: true).order(created_at: :desc) }
  scope :pending, -> { where(approved: false).order(created_at: :desc) }
  scope :combined_news_links, -> (news_feed_id) {
    joins('LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id')
      .where("shared_news_feed_links.news_feed_id = #{news_feed_id} OR news_feed_links.news_feed_id = #{news_feed_id} AND news_feed_links.approved = 1").distinct
  }

  scope :combined_news_links_with_segments, -> (news_feed_id, segment_ids) {
    includes(:social_link, :news_link, :group_message)
      .joins("LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id
              LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id
              WHERE shared_news_feed_links.news_feed_id = #{news_feed_id}
                OR news_feed_links.news_feed_id = #{news_feed_id} AND approved = 1
                OR news_feed_link_segments.segment_id IS NULL
                OR news_feed_link_segments.segment_id IN (#{ segment_ids.join(",") })").distinct
  }

  validates :news_feed_id, presence: true

  after_create :approve_link

  # checks if link can automatically be approved
  # links are automatically approved if author is a
  # group leader
  def approve_link
    return if link.nil?

    if GroupPostsPolicy.new(link.author, [link.group]).update?
      self.approved = true
      self.save!
    end
  end

  def link
    return group_message if group_message
    return news_link if news_link
    return social_link if social_link
  end

  # View Count methods
  def increment_view(user)
    view = views.find_or_create_by(user_id: user.id, enterprise_id: user.enterprise_id)
    view.save
  end

  def total_views
    views.count
  end

  def unique_views
    views.all.count
  end

  def total_likes
    likes.count
  end

  def create_view_if_none(user)
    unless views.find_by(user_id: user.id)
      view = views.create(user_id: user.id, enterprise_id: user.enterprise_id)
      view.save
    end
  end

  def self.archive_expired_news(group)
    return unless group.auto_archive?

    expiry_date = DateTime.now.send("#{group.unit_of_expiry_age}_ago", group.expiry_age_for_news)
    news = group.news_feed_links.where('created_at < ?', expiry_date).where(archived_at: nil)

    news.update_all(archived_at: DateTime.now) if news.any?
  end
end
