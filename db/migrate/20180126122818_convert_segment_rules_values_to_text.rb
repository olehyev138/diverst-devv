class ConvertSegmentRulesValuesToText < ActiveRecord::Migration
  def change
    change_column :segment_rules, :values, :text
  end
end
