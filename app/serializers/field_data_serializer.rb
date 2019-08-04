class FieldDataSerializer < ApplicationRecordSerializer
  attributes :data, :id

  belongs_to :field
end
