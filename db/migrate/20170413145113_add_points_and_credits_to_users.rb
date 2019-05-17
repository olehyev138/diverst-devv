class AddPointsAndCreditsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :points, :integer, null: false, default: 0
    add_column :users, :credits, :integer, null: false, default: 0
  end
end
