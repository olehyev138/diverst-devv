class UserRoleSerializer < ApplicationRecordSerializer
  attributes :enterprise, :role_name, :priority, :role_type, :permissions

  def serialize_all_fields
    true
  end
end
