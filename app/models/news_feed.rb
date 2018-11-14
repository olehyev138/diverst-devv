class NewsFeed < ActiveRecord::Base
    belongs_to :group

    has_many :news_feed_links, dependent: :destroy

    has_many :additional_news_feed_links, :class_name => "SharedNewsFeedLink", source: :news_feed
    has_many :shared_news_feed_links, :through => :additional_news_feed_links, source: :news_feed_link

    validates :group_id, presence: true

    def self.all_links(news_feed_id, segments, enterprise)
        links = all_links_without_segments(news_feed_id, enterprise)
        unless segments.nil? || segments.empty?
            return links.joins("LEFT OUTER JOIN news_feed_link_segments ON news_feed_link_segments.news_feed_link_id = news_feed_links.id").where("news_feed_link_segments.segment_id IS NULL OR news_feed_link_segments.segment_id IN (#{ segments.join(",") })")
        else
            return links.includes(:news_feed_link_segments).where(:news_feed_link_segments => {:id => nil})
        end
    end

    def self.all_links_without_segments(news_feed_id, enterprise)
      if enterprise.enable_social_media?
        return NewsFeedLink.combined_news_links(news_feed_id)
      else
        return NewsFeedLink.combined_news_links(news_feed_id).where("news_feed_links.social_link_id IS NULL")
      end
    end
end
