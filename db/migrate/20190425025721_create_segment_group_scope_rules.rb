class CreateSegmentGroupScopeRules < ActiveRecord::Migration
  def change
    create_table :segment_group_scope_rules do |t|
      t.belongs_to :segment, index: true
      t.integer :operator, null: false
      t.timestamps null: false
    end
  end
end
