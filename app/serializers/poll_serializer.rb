class PollSerializer < ApplicationRecordSerializer
  attributes :groups, :segments, :fields_count, :responses_count, :permissions

  has_many :fields

  def serialize_all_fields
    true
  end
end
