class NewsFeedLike < ActiveRecord::Base
  belongs_to :news_feed_link
  belongs_to :user
end
