class UserMentorshipLiteSerializer < ApplicationRecordSerializer
  attributes :id, :first_name, :last_name, :enterprise_id, :avatar_location, :mentor, :mentee, :time_zone,
             :accepting_mentor_requests, :accepting_mentee_requests, :mentorship_description,
             :interests, :types, :name, :email

  def interests
    object.mentoring_interests.map { |i| i.name.capitalize }.join(', ')
  end

  def types
    object.mentoring_types.map { |i| i.name.capitalize }.join(', ')
  end

  def availabilities
    object.availabilities.map do |ava|
      MentorshipAvailabilitySerializer.new(ava, time_zone: scope[:current_user].time_zone).as_json
    end
  end
end
