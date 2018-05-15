class NewsFeed < ActiveRecord::Base
  belongs_to :group

  has_many :news_feed_links
  has_and_belongs_to_many :shared_news_feed_links, class_name: 'NewsFeedLink', join_table: 'news_feeds_news_feed_links'

  validates :group_id, presence: true
end
