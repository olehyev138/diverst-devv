class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.belongs_to :enterprise
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
