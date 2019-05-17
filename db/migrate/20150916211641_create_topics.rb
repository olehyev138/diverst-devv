class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.text :statement
      t.date :expiration
      t.belongs_to :user
      t.belongs_to :enterprise
      t.belongs_to :category

      t.timestamps null: false
    end
  end
end
