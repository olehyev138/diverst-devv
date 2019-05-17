class AddGroupsAndSegmentsToGraphs < ActiveRecord::Migration[5.1]
  def change
    change_table :graphs do |t|
      t.string :custom_field
      t.string :custom_aggregation
    end
  end
end
