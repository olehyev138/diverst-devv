class MentorshipSessionSerializer < ApplicationRecordSerializer
  attributes :user, :status

  has_one :mentoring_session

  def user
    UserMentorshipLiteSerializer.new(object.user, scope: scope).as_json
  end

  def status
    if object.mentoring_session.creator_id == object.user_id
      'leading'
    else
      object.status
    end
  end

  def serialize_all_fields
    true
  end
end
