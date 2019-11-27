class MentorshipSessionSerializer < ApplicationRecordSerializer
  attributes :user

  has_one :mentoring_session

  def user
    UserMentorshipLiteSerializer.new(object.user, scope: scope, scope_name: :scope).as_json
  end

  def serialize_all_fields
    true
  end
end
