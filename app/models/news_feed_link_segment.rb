class NewsFeedLinkSegment < ActiveRecord::Base
    belongs_to :news_feed_link
    belongs_to :segment
    belongs_to :link_segment, :polymorphic => true
    
    # I removed the validation for now since it has a lot of unnecessary fields
    # validates :news_feed_link,  presence: true, :on => :update
    # validates :segment,         presence: true, :on => :update
    # validates :link_segment,    presence: true, :on => :update

end