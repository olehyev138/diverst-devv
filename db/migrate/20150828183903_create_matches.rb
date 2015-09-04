class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.belongs_to :user1
      t.belongs_to :user2
      t.integer :user1_status, default: 0
      t.integer :user2_status, default: 0
      t.float :score
      t.time :score_calculated_at

      t.timestamps null: false
    end
  end
end
