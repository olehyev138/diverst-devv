class RenameFieldRuleValuesToData < ActiveRecord::Migration[5.1]
  def change
    rename_column :segment_field_rules, :values, :data
  end
end
