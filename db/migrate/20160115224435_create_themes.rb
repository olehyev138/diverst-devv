class CreateThemes < ActiveRecord::Migration[5.1]
  def change
    create_table :themes do |t|
      t.attachment :logo
      t.string :primary_color
      t.string :digest
      t.boolean :default, default: false
    end
  end
end
