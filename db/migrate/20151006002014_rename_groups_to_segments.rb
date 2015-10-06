class RenameGroupsToSegments < ActiveRecord::Migration
  def change
    rename_table :employees_groups, :employees_segments
    rename_column :employees_segments, :group_id, :segment_id

    rename_table :groups, :segments

    rename_table :group_rules, :segment_rules
    rename_column :segment_rules, :group_id, :segment_id
  end
end
