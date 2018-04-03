class MentoringSession < ActiveRecord::Base
    # associations
    has_many :mentoring_ratings
    
    has_many :mentoring_session_topics
    has_many :mentoring_interests, :through => :mentoring_session_topics
    has_many :mentorship_sessions
    has_many :mentorships, :through => :mentorship_sessions
    
    # validations
    validates :start,   presence: true
    validates :end,     presence: true
    validates :status,  presence: true
end
