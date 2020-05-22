class GroupMessageSerializer < ApplicationRecordSerializer
  attributes :comments_count, :news_feed_link_id

  has_one :owner
  has_many :comments

  def news_feed_link_id
    object.news_feed_link.id
  end

  def serialize_all_fields
    true
  end
end
