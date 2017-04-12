class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.references :enterprise, index: true, foreign_key: true, null: false
      t.integer :points, null: false
      t.string :label, null: false
      t.attachment :image, null: false
    end
  end
end
