class UpdateSerializer < ApplicationRecordSerializer
  has_many :field_data

  def excluded_keys
    [:updatable_type, :updatable_id]
  end
end
