class MentorshipSessionSerializer < ApplicationRecordSerializer
  attributes :user

  has_one :mentoring_session

  def user
    UserMentorshipLiteSerializer.new(object.user).as_json
  end

  def serialize_all_fields
    true
  end
end
