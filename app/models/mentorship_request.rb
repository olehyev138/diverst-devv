class MentorshipRequest < ActiveRecord::Base
    # associations
    belongs_to :mentorship
    belongs_to :mentoring_request
    
    # validations
    validates :mentorship,          presence: true
    validates :mentoring_request,   presence: true
end
