class PollSerializer < ApplicationRecordSerializer
  attributes :groups, :segments, :fields_count, :responses_count, :permissions

  has_many :fields, each_serializer: FieldSerializer

  def serialize_all_fields
    true
  end
end
