class NewsFeedLinkSegment < ActiveRecord::Base
    belongs_to :news_feed_link
    belongs_to :segment
    belongs_to :news_link_segment
    belongs_to :group_messages_segment
    belongs_to :social_link_segment

    validates :news_feed_link,  presence: true
    validates :segment,         presence: true

end