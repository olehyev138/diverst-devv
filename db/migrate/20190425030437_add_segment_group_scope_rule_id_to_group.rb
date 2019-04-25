class AddSegmentGroupScopeRuleIdToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :segment_group_scope_rule, index: true, foreign_key: true
  end
end
