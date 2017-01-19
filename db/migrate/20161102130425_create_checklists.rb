class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.integer :subject_id
      t.string :subject_type

      t.string :title

      t.integer :author_id

      t.timestamps null: false
    end
  end
end
