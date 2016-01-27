class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.belongs_to :enterprise
      t.string :name

      t.timestamps null: false
    end
  end
end
