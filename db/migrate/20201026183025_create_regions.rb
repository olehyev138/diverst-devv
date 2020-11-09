class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.text :short_description
      t.text :description
      t.text :home_message
      t.integer :position
      t.boolean :private, default: false
      t.references :parent, foreign_key: { to_table: :groups }, null: false
    end
  end
end
