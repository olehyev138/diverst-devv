class CreateRewards < ActiveRecord::Migration[5.1]
  def change
    create_table :rewards do |t|
      t.references :enterprise, index: true, foreign_key: true, null: false
      t.integer :points, null: false
      t.string :label, null: false
      t.attachment :picture
      t.text :description
      t.integer :responsible_id, index: true, null: false
      t.foreign_key :users, column: :responsible_id

      t.timestamps
    end
  end
end
