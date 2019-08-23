class RefactorSegmentRuleName < ActiveRecord::Migration[5.1]
  def change
    rename_table :segment_rules, :segment_field_rules
  end
end
