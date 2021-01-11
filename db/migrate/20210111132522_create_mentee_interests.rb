class CreateMenteeInterests < ActiveRecord::Migration
  def change
    create_table :mentee_interests do |t|
      t.string :name
      t.references :enterprise, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
