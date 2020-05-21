class NewsFeed < BaseClass
  belongs_to :group

  has_many :news_feed_links, dependent: :destroy

  has_many :additional_news_feed_links, class_name: 'SharedNewsFeedLink', source: :news_feed
  has_many :shared_news_feed_links, through: :additional_news_feed_links, source: :news_feed_link

  validates :group_id, presence: true

  def all_links(segment_ids)
    NewsFeedLink.combined_news_links(id, group.enterprise, segment_ids: segment_ids).active
  end

  def all_links_without_segments
    NewsFeedLink.combined_news_links(id, group.enterprise, without_segments: true).active
  end

  def self.archived_posts(enterprise)
    groups = enterprise.groups
    news_feed_link_ids = []
    groups.each do |group|
      news_feed_link_ids += group.news_feed.news_feed_links.where.not(archived_at: nil).ids
    end
    NewsFeedLink.where(id: news_feed_link_ids)
  end
end
