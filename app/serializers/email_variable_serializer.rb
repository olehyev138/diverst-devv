class EmailVariableSerializer < ApplicationRecordSerializer
  def excluded_keys
    [:created_at, :updated_at, :id]
  end
end
