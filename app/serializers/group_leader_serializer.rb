class GroupLeaderSerializer < ApplicationRecordSerializer
  attributes :group, :user_role, :position_name

  belongs_to :user

  def serialize_all_fields
    true
  end
end
