class PolicyGroupTemplateSerializer < ApplicationRecordSerializer
  def excluded_keys
    [:created_at, :updated_at, :user_id, :manage_all]
  end
end
