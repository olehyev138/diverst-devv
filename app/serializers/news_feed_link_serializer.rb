class NewsFeedLinkSerializer < ApplicationRecordSerializer
  attributes :id, :news_feed_id, :news_feed, :total_views, :total_likes, :approved, :is_pinned, :permissions

  belongs_to :group_message
  belongs_to :news_link
  belongs_to :social_link
end
