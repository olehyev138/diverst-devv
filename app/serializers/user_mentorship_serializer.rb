class UserMentorshipSerializer < ApplicationRecordSerializer
  attributes :id, :email, :biography, :name, :first_name, :last_name, :enterprise_id, :avatar_location,
             :mentor, :mentee, :mentors, :mentees, :accepting_mentor_requests, :accepting_mentee_requests, :mentorship_description,
             :availabilities, :time_zone, :interests, :types

  has_many :mentorship_ratings
  has_many :mentoring_interests
  has_many :mentoring_types

  # Serialize all user fields, including the custom attributes listed above, and excluding the `excluded_keys`

  def interests
    object.mentoring_interests.map { |i| i.name.capitalize }.join(', ')
  end

  def types
    object.mentoring_types.map { |i| i.name.capitalize }.join(', ')
  end

  def mentors
    object.mentors.map do |m|
      UserMentorshipLiteSerializer.new(m, scope: scope, scope_name: :scope).as_json
    end
  end

  def mentees
    object.mentees.map do |m|
      UserMentorshipLiteSerializer.new(m, scope: scope, scope_name: :scope).as_json
    end
  end

  def avatar_location
    object.avatar_location(default_style: instance_options.dig(:scope, :image_size)&.to_sym)
  end

  def excluded_keys
    [:password_digest]
  end

  def availabilities
    object.availabilities.map do |ava|
      MentorshipAvailabilitySerializer.new(ava, time_zone: scope.dig(:current_user)&.time_zone).as_json
    end
  end
end
