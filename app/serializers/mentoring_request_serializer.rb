class MentoringRequestSerializer < ApplicationRecordSerializer
  belongs_to :sender
  belongs_to :receiver

  def serialize_all_fields
    true
  end

  def sender
    UserMentorshipLiteSerializer.new(object.sender, scope: scope, scope_name: :scope).as_json
  end

  def receiver
    UserMentorshipLiteSerializer.new(object.receiver, scope: scope, scope_name: :scope).as_json
  end
end
