class RemoveSegmentationsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :segmentations do |t|
      t.integer :parent_id, index: true, limit: 4
      t.integer :child_id, index: true, limit: 4
      t.timestamps null: false
    end
  end
end
