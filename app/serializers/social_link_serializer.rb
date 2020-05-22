class SocialLinkSerializer < ApplicationRecordSerializer
  attributes :author, :url, :news_feed_link_id

  def news_feed_link_id
    news_feed_link.id
  end

  def serialize_all_fields
    true
  end
end
