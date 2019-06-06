class CreateSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :segments do |t|
      t.belongs_to :enterprise
      t.string :name

      t.timestamps null: false
    end
  end
end
