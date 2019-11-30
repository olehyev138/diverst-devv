class MentoringSerializer < ApplicationRecordSerializer
  attributes :mentor, :mentee

  def mentor
    UserMentorshipLiteSerializer.new(object.mentor, scope: scope, scope_name: :scope).as_json
  end

  def mentee
    UserMentorshipLiteSerializer.new(object.mentee, scope: scope, scope_name: :scope).as_json
  end
end
