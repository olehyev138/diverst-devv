class MentoringSerializer < ApplicationRecordSerializer
  attributes :mentor, :mentee

  def mentor
    UserMentorshipLiteSerializer.new(object.mentor, scope: scope).as_json
  end

  def mentee
    UserMentorshipLiteSerializer.new(object.mentee, scope: scope).as_json
  end
end
