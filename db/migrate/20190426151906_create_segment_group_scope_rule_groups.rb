class CreateSegmentGroupScopeRuleGroups < ActiveRecord::Migration
  def change
    create_table :segment_group_scope_rule_groups do |t|
      t.belongs_to :segment_group_scope_rule, index: { name: 'segment_group_rule_group_index' }
      t.belongs_to :group, index: true
      t.timestamps null: false
    end
  end
end
