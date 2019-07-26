class UserRoleSerializer < ApplicationRecordSerializer
  attributes :enterprise

  def serialize_all_fields
    true
  end
end
