class MentorshipType < ActiveRecord::Base
    # associations
    belongs_to  :mentorship
    belongs_to  :mentorship_type
    
    # validations
    validates :mentorship,      presence: true
    validates :mentorship_type, presence: true
end
