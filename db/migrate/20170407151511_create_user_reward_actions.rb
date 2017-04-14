class CreateUserRewardActions < ActiveRecord::Migration
  def change
    create_table :user_reward_actions do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :reward_action, index: true, foreign_key: true, null: false
      t.references :entity, polymorphic: true
      t.integer :operation, null: false
      t.integer :points, null: false

      t.timestamps
    end
  end
end
