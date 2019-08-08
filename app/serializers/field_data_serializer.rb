class FieldDataSerializer < ApplicationRecordSerializer
  attributes :data, :id, :field_id, :user_id

  belongs_to :field
end
