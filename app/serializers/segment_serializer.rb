class SegmentSerializer < ApplicationRecordSerializer
  attributes :owner, :all_rules_count

  def serialize_all_fields
    true
  end
end
