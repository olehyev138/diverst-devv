class MentoringSession < ActiveRecord::Base
    # associations
    has_many :mentoring_ratings
    
    has_many :mentoring_session_topics
    has_many :mentoring_interests, :through => :mentoring_session_topics
    
    # validations
    validates :start,   presence: true
    validates :end,     presence: true
    validates :status,  presence: true
end
