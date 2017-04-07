class CreateUserRewardActions < ActiveRecord::Migration
  def change
    create_table :user_reward_actions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :reward_action, index: true, foreign_key: true
    end
  end
end
