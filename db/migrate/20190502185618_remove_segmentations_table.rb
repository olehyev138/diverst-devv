class RemoveSegmentationsTable < ActiveRecord::Migration
  def change
    drop_table :segmentations do |t|
      t.integer :parent_id, index: true, limit: 4
      t.integer :child_id, index: true, limit: 4
      t.timestamps null: false
    end
  end
end
