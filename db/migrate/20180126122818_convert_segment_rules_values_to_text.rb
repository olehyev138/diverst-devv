class ConvertSegmentRulesValuesToText < ActiveRecord::Migration[5.1]
  def change
    change_column :segment_rules, :values, :text
  end
end
