class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.belongs_to :user1
      t.belongs_to :user2
      t.integer :score
      t.date :score_calculated_at

      t.timestamps null: false
    end
  end
end
