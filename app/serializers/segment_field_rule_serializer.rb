class SegmentFieldRuleSerializer < ApplicationRecordSerializer
  belongs_to :field

  def serialize_all_fields
    true
  end
end
