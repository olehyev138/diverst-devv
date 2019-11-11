class NewsFeedLinkTag < ActiveRecord::Base
  belongs_to :news_tag, foreign_key: :news_tag_name
  belongs_to :news_feed_link
end
