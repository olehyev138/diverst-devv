class NewsFeedLinkTag < ActiveRecord::Base
  belongs_to :news_tag
  belongs_to :news_feed_link
end