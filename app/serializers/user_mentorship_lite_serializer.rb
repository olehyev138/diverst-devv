class UserMentorshipLiteSerializer < ApplicationRecordSerializer
  attributes :id, :first_name, :last_name, :enterprise_id, :avatar_location, :mentor, :mentee,
             :accepting_mentor_requests, :accepting_mentee_requests, :mentorship_description

  has_many :availabilities
  has_many :mentoring_interests
  has_many :mentoring_types
end
