class UserRoleSerializer < ApplicationRecordSerializer
  attributes :enterprise, :role_name

  def serialize_all_fields
    true
  end
end
