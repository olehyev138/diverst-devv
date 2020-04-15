class UserMentorshipLiteSerializer < ApplicationRecordSerializer
  attributes :id, :first_name, :last_name, :enterprise_id, :avatar_location, :mentor, :mentee, :time_zone,
             :accepting_mentor_requests, :accepting_mentee_requests, :mentorship_description,
             :interests, :types, :name, :email, :availabilities, :permissions

  has_many :mentoring_interests
  has_many :mentoring_types

  def interests
    inters = object.mentoring_interests.map do |i|
      i.name.split(' ').map { |j| j.capitalize }.join(' ')
    end
    inters.last.prepend 'and ' if inters.count > 1
    inters.count > 2 ? inters.join(', ') : inters.join(' ')
  end

  def types
    typs = object.mentoring_types.map do |i|
      i.name.split(' ').map { |j| j.capitalize }.join(' ')
    end
    typs.last.prepend 'and ' if typs.count > 1
    typs.count > 2 ? typs.join(', ') : typs.join(' ')
  end

  def availabilities
    object.availabilities.map do |ava|
      MentorshipAvailabilitySerializer.new(ava, time_zone: scope.dig(:current_user)&.time_zone).as_json
    end
  end
end
