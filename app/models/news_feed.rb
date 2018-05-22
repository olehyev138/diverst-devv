class NewsFeed < ActiveRecord::Base
  belongs_to :group

  has_many :news_feed_links
  has_many :share_links, dependent: :destroy
  has_many :shared_news_feed_links, through: :share_links, source: :news_feed_link

  validates :group_id, presence: true
end
