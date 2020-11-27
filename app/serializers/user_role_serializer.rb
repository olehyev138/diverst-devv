class UserRoleSerializer < ApplicationRecordSerializer
  attributes :role_name, :priority, :role_type, :permissions

  def serialize_all_fields
    true
  end
end
