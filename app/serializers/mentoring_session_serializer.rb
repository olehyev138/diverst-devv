class MentoringSessionSerializer < ApplicationRecordSerializer
  attributes :creator, :interests, :users, :current_user_session, :permissions

  has_many :mentoring_interests

  def serialize_all_fields
    true
  end

  def interests
    inters = object.mentoring_interests.map do |i|
      i.name.split(' ').map { |j| j.capitalize }.join(' ')
    end
    inters.last.prepend 'and ' if inters.count > 1
    inters.count > 2 ? inters.join(', ') : inters.join(' ')
  end

  def creator
    UserMentorshipSerializer.new(object.creator, scope: scope, scope_name: :scope).as_json
  end

  def users
    object.users.map do |user|
      UserMentorshipLiteSerializer.new(user, scope: scope, scope_name: :scope).as_json
    end
  end

  def current_user_session
    scope&.dig(:current_user)&.get_mentorship_session(object)
  end
end
