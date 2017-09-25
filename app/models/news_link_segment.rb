class NewsLinkSegment < ActiveRecord::Base
    belongs_to :news_link
    belongs_to :segment
    
    validates :news_link_id, presence: true
    validates :segment_id, presence: true
    
end
