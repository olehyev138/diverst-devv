class CreateUserRewards < ActiveRecord::Migration
  def change
    create_table :user_rewards do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :reward, index: true, foreign_key: true, null: false
      t.integer :points, null: false

      t.timestamps
    end
  end
end
