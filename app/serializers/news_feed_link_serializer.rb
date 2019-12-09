class NewsFeedLinkSerializer < ApplicationRecordSerializer
  attributes :id, :news_feed_id, :news_feed, :news_link, :social_link, :total_views, :total_likes, :approved

  belongs_to :group_message
end
