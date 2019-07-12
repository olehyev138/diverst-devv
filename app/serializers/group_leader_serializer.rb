class GroupLeaderSerializer < ApplicationRecordSerializer
  attributes :group, :user, :user_role

  def serialize_all_fields
    true
  end
end
