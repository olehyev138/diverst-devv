class CreateSegmentations < ActiveRecord::Migration
    def up
        create_table :segmentations do |t|
            t.references :parent
            t.references :child
            t.timestamps null: false
        end

        add_foreign_key :segmentations, :segments, column: :child_id
        add_index :segmentations, [:parent_id, :child_id], unique: true
    end
    
    def down
        drop_table :segmentations
    end
end
