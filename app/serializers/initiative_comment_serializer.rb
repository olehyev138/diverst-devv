class InitiativeCommentSerializer < ApplicationRecordSerializer
  attributes :user, :initiative_id, :user_name, :time_since_creation, :permissions

  has_one :user
  def serialize_all_fields
    true
  end
end
