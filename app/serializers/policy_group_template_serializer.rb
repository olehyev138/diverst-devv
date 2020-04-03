class PolicyGroupTemplateSerializer < ApplicationRecordSerializer
  attributes :permissions

  def serialize_all_fields
    true
  end

  def excluded_keys
    [:created_at, :updated_at, :user_id, :manage_all]
  end
end
