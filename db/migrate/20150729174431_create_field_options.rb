class CreateFieldOptions < ActiveRecord::Migration
  def change
    create_table :field_options do |t|
      t.string :title
      t.belongs_to :field

      t.timestamps null: false
    end
  end
end
