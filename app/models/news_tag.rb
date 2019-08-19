class NewsTag < ActiveRecord::Base
  self.primary_key = 'name'
  has_and_belongs_to_many :news_feed_links
end
