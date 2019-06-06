class CreateChecklistItems < ActiveRecord::Migration[5.1]
  def change
    create_table :checklist_items do |t|
      t.integer :checklist_id

      t.string :title

      t.boolean :is_done, default: false

      t.timestamps null: false
    end
  end
end
