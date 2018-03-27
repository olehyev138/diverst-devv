class MentorshipSession < ActiveRecord::Base
    # associations
    belongs_to :mentorship
    belongs_to :mentoring_session
    
    # validations
    validates :mentorship,          presence: true
    validates :mentoring_session,   presence: true
end
