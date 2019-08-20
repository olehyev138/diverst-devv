class NewsTag < ActiveRecord::Base
  self.primary_key = 'name'
  has_many :news_feed_link_tags, foreign_key: :news_tag_name
  has_many :news_feed_links, through: :news_feed_link_tags

  validates_uniqueness_of :name, case_sensitive: false
end
