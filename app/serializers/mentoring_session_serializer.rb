class MentoringSessionSerializer < ApplicationRecordSerializer
  attributes :creator, :interests, :users

  has_many :mentoring_interests

  def serialize_all_fields
    true
  end

  def interests
    object.mentoring_interests.map { |i| i.name }.join(', ')
  end

  def creator
    UserMentorshipSerializer.new(object.creator, scope: scope, scope_name: :scope).as_json
  end

  def users
    object.users.map do |user|
      UserMentorshipLiteSerializer.new(user, scope: scope, scope_name: :scope).as_json
    end
  end
end
