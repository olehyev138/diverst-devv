class MentorshipSessionSerializer < ApplicationRecordSerializer
  has_one :mentoring_session

  def serialize_all_fields
    true
  end
end
