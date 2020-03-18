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

  has_many :news_feed_link_tags
  has_many :news_tags, through: :news_feed_link_tags

  delegate :group,    to: :news_feed
  delegate :segment,  to: :news_feed_link_segment, allow_nil: true

  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }
  scope :combined_news_links, -> (news_feed_id) {
    joins('LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id')
      .where("shared_news_feed_links.news_feed_id = #{news_feed_id} OR news_feed_links.news_feed_id = #{news_feed_id} AND news_feed_links.approved = 1").distinct
  }

  scope :approved,        -> { where(approved: true).order(created_at: :desc) }
  scope :not_approved,    -> (news_feed_id = nil) {
    if news_feed_id.present?
      where(approved: false).where('`news_feed_links`.`news_feed_id` = ?', news_feed_id).order(created_at: :desc)
    else
      where(approved: false).order(created_at: :desc)
    end
  }

  scope :active, -> {
    where(archived_at: nil)
  }

  scope :select_source, -> (news_feed_id) {
    select(
        "`news_feed_links`.`*`, CASE WHEN `news_feed_links`.`news_feed_id` = #{sanitize(news_feed_id)} THEN 'self' "\
        "WHEN `shared_news_feed_links`.`news_feed_id` = #{sanitize(news_feed_id)} THEN 'shared' ELSE 'unknown' END as `source`,  "\
      )
  }

  # TODO: comment & explain this
  scope :combined_news_links, -> (news_feed_id, enterprise, segment_ids: [], without_segments: false) {
    if without_segments
      left_joins(:shared_news_feed_links)
          .where('shared_news_feed_links.news_feed_id = ?'\
                 ' OR news_feed_links.news_feed_id = ?',
                 news_feed_id, news_feed_id
          ).distinct
    else
      if segment_ids.empty?
        left_joins(:shared_news_feed_links, :news_feed_link_segments)
            .where('(shared_news_feed_links.news_feed_id = ?'\
                 ' OR news_feed_links.news_feed_id = ?)'\
                 ' AND news_feed_link_segments.segment_id IS NULL',
                   news_feed_id, news_feed_id
            ).distinct
      else
        left_joins(:shared_news_feed_links, :news_feed_link_segments)
            .where('(shared_news_feed_links.news_feed_id = ?'\
                 ' OR news_feed_links.news_feed_id = ?)'\
                 ' AND (news_feed_link_segments.segment_id IS NULL'\
                 ' OR news_feed_link_segments.segment_id IN (?))',
                   news_feed_id, news_feed_id, segment_ids
            ).distinct
      end
    end.filter_posts(social_enabled: enterprise.enable_social_media?)
  }

  scope :include_posts, -> (social_enabled: false) {
    if social_enabled
      includes(:news_link, :group_message, :social_link)
    else
      includes(:news_link, :group_message)
    end
  }

  scope :not_archived, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  scope :pinned, -> { where(is_pinned: true) }
  scope :not_pinned, -> { where(is_pinned: false) }

  scope :combined_news_links_with_segments, -> (news_feed_id, segment_ids) {
    includes(:social_link, :news_link, :group_message)
        .joins("LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id
              LEFT OUTER JOIN shared_news_feed_links ON shared_news_feed_links.news_feed_link_id = news_feed_links.id
              WHERE shared_news_feed_links.news_feed_id = #{news_feed_id}
              OR news_feed_links.news_feed_id = #{news_feed_id} AND approved = 1
              OR news_feed_link_segments.segment_id IS NULL
              OR news_feed_link_segments.segment_id IN (#{ segment_ids.join(",") })").distinct
  }

  scope :filter_posts, -> (social_enabled: false) {
    if social_enabled
      where('group_message_id IS NOT NULL OR news_link_id IS NOT NULL OR social_link_id IS NOT NULL')
    else
      where('group_message_id IS NOT NULL OR news_link_id IS NOT NULL')
    end
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
    group_message || news_link || social_link
  end

  # View Count methods
  def increment_view(user)
    view = views.find_or_create_by(user_id: user.id, enterprise_id: user.enterprise_id)
    view.save
  end

  def total_views
    views.size
  end

  def unique_views
    views.all.count
  end

  def total_likes
    likes.size
  end

  def create_view_if_none(user)
    unless views.find_by(user_id: user.id)
      view = views.create(user_id: user.id, enterprise_id: user.enterprise_id)
      view.save
    end
  end

  def to_label
    if group_message_id.present?
      group_message.to_label
    elsif news_link_id.present?
      news_link.to_label
    elsif social_link_id.present?
      social_link.to_label
    else
      super
    end
  end

  def self.archive_expired_news(group)
    return unless group.auto_archive?

    expiry_date = DateTime.now.send("#{group.unit_of_expiry_age}_ago", group.expiry_age_for_news)
    news = group.news_feed_links.where('created_at < ?', expiry_date).where(archived_at: nil)

    news.update_all(archived_at: DateTime.now) if news.any?
  end

  def self.search(search)
    if search
      left_joins(:group_message, :news_link, :news_tags)
          .where(
              [
                  (
                  [
                      'news_tags.name LIKE ? OR ' +
                          'LOWER( group_messages.subject ) LIKE ? OR ' +
                          'LOWER( group_messages.content ) LIKE ? OR ' +
                          'LOWER( news_links.title ) LIKE ? OR ' +
                          'LOWER( news_links.description ) LIKE ?'
                  ] * search.length
                ).join(' OR ')
              ] + search.reduce([]) { |sum, term| sum + ["#{term.downcase}"] + (["%#{term.downcase}%"] * 4) })
    else
      all
    end
  end
end
