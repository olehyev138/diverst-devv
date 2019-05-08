class GroupMessagesSegment < BaseClass
  belongs_to :group_message
  belongs_to :segment

  has_one :news_feed_link_segment, dependent: :destroy

  validates :group_message_id,    presence: true, on: :save
  validates :segment_id,          presence: true, on: :save

  before_create :build_default_link_segment

  def build_default_link_segment
    build_news_feed_link_segment(segment: segment, news_feed_link: group_message.news_feed_link)
    true
  end
end
