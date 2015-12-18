class AddGroupsAndSegmentsToGraphs < ActiveRecord::Migration
  def change
    change_table :graphs do |t|
      t.string :custom_field
      t.string :custom_aggregation
    end
  end
end
