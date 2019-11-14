class MentoringSerializer < ApplicationRecordSerializer
  attributes :mentor, :mentee

  def mentor
    UserMentorshipLiteSerializer.new(object.mentor).as_json
  end

  def mentee
    UserMentorshipLiteSerializer.new(object.mentee).as_json
  end
end
