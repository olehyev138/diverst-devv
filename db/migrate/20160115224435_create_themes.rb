class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.attachment :logo
      t.string :primary_color
      t.string :digest
    end
  end
end
