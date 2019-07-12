class NewsFeedLinkSerializer < ApplicationRecordSerializer
  attributes :news_feed_id, :group_message, :news_link, :social_link, :total_views, :total_likes
end
