class FieldDataSerializer < ApplicationRecordSerializer
  attributes :data, :id, :field_id, :fieldable_id, :fieldable_type

  belongs_to :field
end
