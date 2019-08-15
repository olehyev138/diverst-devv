class CreateFieldData < ActiveRecord::Migration[5.1]
  def change
    create_table :field_data do |t|
      t.references :user
      t.references :field
      t.string :data

      t.timestamps
    end
  end
end
