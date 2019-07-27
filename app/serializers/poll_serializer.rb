class PollSerializer < ApplicationRecordSerializer
  attributes :fields, :groups, :segments

  def serialize_all_fields
    true
  end
end
