class EmailVariableSerializer < ApplicationRecordSerializer
  def serialize_all_fields
    true
  end

  def excluded_keys
    [:created_at, :updated_at, :id]
  end
end
