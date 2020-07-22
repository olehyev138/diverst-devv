class MentoringRequestSerializer < ApplicationRecordSerializer
  attributes :sender, :receiver

  def serialize_all_fields
    true
  end

  def sender
    UserMentorshipSerializer.new(object.sender, scope: scope).as_json
  end

  def receiver
    UserMentorshipSerializer.new(object.receiver, scope: scope).as_json
  end
end
