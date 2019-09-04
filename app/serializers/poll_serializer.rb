class PollSerializer < ApplicationRecordSerializer
  attributes :groups, :segments

  has_many :fields, each_serializer: FieldSerializer

  def serialize_all_fields
    true
  end
end
