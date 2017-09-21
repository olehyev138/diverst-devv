class SocialLinkSegment < ActiveRecord::Base
    belongs_to :social_link
    belongs_to :segment
    
    validates :social_link_id, presence: true
    validates :segment_id, presence: true
end
