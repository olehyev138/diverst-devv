class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.text :statement
      t.date :expiration
      t.belongs_to :admin
      t.belongs_to :enterprise
      t.belongs_to :category

      t.timestamps null: false
    end
  end
end
