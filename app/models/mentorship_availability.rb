class MentorshipAvailability < ActiveRecord::Base
    # associations
    belongs_to :mentorship
    
    # validations
    validates :mentorship,  presence: true
    validates :start,       presence: true
    validates :end,         presence: true
end
