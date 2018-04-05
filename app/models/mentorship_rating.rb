class MentorshipRating < ActiveRecord::Base
    # associations
    belongs_to :user
    belongs_to :mentoring_session
    
    # validations
    validates :user,                presence: true
    validates :mentoring_session,   presence: true
    validates :rating,              presence: true
end
