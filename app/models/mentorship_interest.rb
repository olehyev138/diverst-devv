class MentorshipInterest < ActiveRecord::Base
    # associations
    belongs_to :mentorship
    belongs_to :mentoring_interest
    
    # validations
    validates :mentorship,          presence: true
    validates :mentoring_interest,  presence: true
end
