class SharedNewsFeedLink < ApplicationRecord
  belongs_to  :news_feed
  belongs_to  :news_feed_link
end
