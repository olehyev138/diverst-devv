class Mentorship < ActiveRecord::Base
    # associations
    belongs_to :user
    
	has_many :mentees,          class_name: "Mentoring", foreign_key: "mentor_id"
	has_many :mentors,          class_name: "Mentoring", foreign_key: "mentee_id"
	has_many :availabilities,   :class_name => "MentorshipAvailability"
	has_many :mentorship_types
    has_many :mentorship_ratings
        
    # many to many
    has_many :mentorship_interests
    has_many :mentoring_interests, :through => :mentorship_interests
    
    has_many :mentorship_requests
    has_many :mentoring_requests, :through => :mentorship_requests
    
    has_many :mentorship_sessions
    has_many :mentoring_sessions, :through => :mentorship_sessions

    # mentorship_requests
    has_many :mentorship_requests,  :foreign_key => "sender_id",     :class_name => "MentoringRequest"
    has_many :mentorship_proposals, :foreign_key => "receiver_id",   :class_name => "MentoringRequest"
    
    # validations
    validates :user,        presence: true
    validates :description, presence: true
end
