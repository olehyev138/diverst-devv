class UserRoleSerializer < ApplicationRecordSerializer
  attributes :enterprise, :role_name, :priority, :role_type

  def serialize_all_fields
    true
  end
end
