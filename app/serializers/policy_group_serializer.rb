class PolicyGroupSerializer < ApplicationRecordSerializer
  def excluded_keys
    [:id, :created_at, :updated_at, :user_id]
  end
end
