class NewsFeedLinkSegment < ActiveRecord::Base
    belongs_to :news_feed_link
    belongs_to :segment
    belongs_to :link_segment, :polymorphic => true
    
    validates :news_feed_link,  presence: true
    validates :segment,         presence: true
    validates :link_segment,    presence: true

end