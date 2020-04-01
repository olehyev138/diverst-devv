class NewsFeedLinkSerializer < ApplicationRecordSerializer
  attributes :id, :news_feed_id, :news_feed, :total_views, :total_likes, :approved, :is_pinned, :current_user_likes, :permissions

  def current_user_likes
    object.user_like scope&.dig(:current_user)&.id
  end

  belongs_to :group_message
  belongs_to :news_link
  belongs_to :social_link
end
