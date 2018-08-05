class NewsFeed < ActiveRecord::Base
    belongs_to :group

    has_many :news_feed_links, dependent: :destroy

    has_many :additional_news_feed_links, :class_name => "SharedNewsFeedLink", source: :news_feed
    has_many :shared_news_feed_links, :through => :additional_news_feed_links, source: :news_feed_link
    
    validates :group_id, presence: true
end
