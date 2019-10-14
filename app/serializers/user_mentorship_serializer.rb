class UserMentorshipSerializer < ApplicationRecordSerializer
  attributes :id, :first_name, :last_name, :enterprise_id, :avatar_location, :mentors, :mentees

  has_many :mentors
  has_many :mentees
  has_many :availabilities
  has_many :mentorship_ratings
  has_many :mentoring_interests
  has_many :mentoring_sessions
  has_many :mentoring_types
  has_many :mentorship_proposals
  has_many :mentorship_requests

  # Serialize all user fields, including the custom attributes listed above, and excluding the `excluded_keys`

  def mentors
    object.mentors.map do |m|
      UserMentorshipLiteSerializer.new(m).as_json
    end
  end

  def mentees
    object.mentees.map do |m|
      UserMentorshipLiteSerializer.new(m).as_json
    end
  end

  def avatar_location
    object.avatar_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def excluded_keys
    [:password_digest]
  end
end
