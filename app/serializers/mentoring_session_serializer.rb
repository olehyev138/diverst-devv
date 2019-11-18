class MentoringSessionSerializer < ApplicationRecordSerializer
  attributes :creator

  def serialize_all_fields
    true
  end

  def creator
    UserMentorshipLiteSerializer.new(object.creator).as_json
  end
end
