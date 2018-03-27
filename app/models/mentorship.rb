class Mentorship < ActiveRecord::Base
    # associations
    belongs_to :user
    
	has_many :mentees,          class_name: "Mentoring", foreign_key: "mentor_id"
	has_many :mentors,          class_name: "Mentoring", foreign_key: "mentee_id"
	has_many :availabilities,   :class_name => "MentorshipAvailability"
	has_many :mentorship_types
    
    has_many :mentorship_interests
    has_many :mentoring_interests, :through => :mentorship_interests
    
    # validations
    validates :user,        presence: true
    validates :description, presence: true
end
