class SegmentGroupScopeRuleGroup < ActiveRecord::Base
  belongs_to :segment_group_scope_rule
  belongs_to :group
end
