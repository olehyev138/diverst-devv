class InitiativeCommentSerializer < ApplicationRecordSerializer
  attributes :user, :initiative, :user_name

  def serialize_all_fields
    true
  end
end
