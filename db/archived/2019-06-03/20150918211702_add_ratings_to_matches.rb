class AddRatingsToMatches < ActiveRecord::Migration[5.1]
  def change
    change_table :matches do |t|
      t.integer :user1_rating, min: 1, max: 5
      t.integer :user2_rating, min: 1, max: 5
    end
  end
end
