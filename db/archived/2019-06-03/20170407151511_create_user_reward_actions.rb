class CreateUserRewardActions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_reward_actions do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :reward_action, index: true, foreign_key: true, null: false
      t.references :entity, polymorphic: true
      t.integer :operation, null: false, index: true
      t.integer :points, null: false

      t.timestamps
    end
  end
end
