class InitiativeCommentSerializer < ApplicationRecordSerializer
  attributes :user, :initiative, :user_name, :time_since_creation

  def serialize_all_fields
    true
  end
end
