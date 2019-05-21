class NewsFeedLinkSegment < BaseClass
  belongs_to :news_feed_link
  belongs_to :segment
  belongs_to :news_link_segment
  belongs_to :group_messages_segment
  belongs_to :social_link_segment

  # I removed the validation for now since it has a lot of unnecessary fields
  # validates :news_feed_link,  presence: true, :on => :update
  # validates :segment,         presence: true, :on => :update
  # validates :link_segment,    presence: true, :on => :update
end
