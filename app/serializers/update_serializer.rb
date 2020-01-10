class UpdateSerializer < ApplicationRecordSerializer
  has_many :field_data

  def serialize_all_fields
    true
  end

  def excluded_keys
    [:updatable_type, :updatable_id]
  end
end
