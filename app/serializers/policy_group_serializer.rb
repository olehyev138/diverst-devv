class PolicyGroupSerializer < ApplicationRecordSerializer
  def serialize_all_fields
    true
  end

  def excluded_keys
    [:id, :created_at, :updated_at, :user_id]
  end
end
