class SegmentGroupScopeRuleSerializer < ApplicationRecordSerializer

  has_many :groups, key: :group_ids

  def serialize_all_fields
    true
  end
end
