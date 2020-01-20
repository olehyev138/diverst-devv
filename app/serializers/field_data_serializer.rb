class FieldDataSerializer < ApplicationRecordSerializer
  attributes :data, :id, :field_id, :field_user_id, :field_user_type

  belongs_to :field
end
