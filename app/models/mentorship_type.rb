class MentorshipType < ActiveRecord::Base
    # associations
    belongs_to  :mentorship
    belongs_to  :mentoring_type
    
    # validations
    validates :mentorship,      presence: true
    validates :mentoring_type,  presence: true
end
