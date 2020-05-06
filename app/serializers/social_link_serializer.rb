class SocialLinkSerializer < ApplicationRecordSerializer
  attributes :author, :url, :news_feed_link_id

  def serialize_all_fields
    true
  end
end
