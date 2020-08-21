class AddColumnToUserRewardActions < ActiveRecord::Migration
  def change
    add_column :user_reward_actions, :user_group_id, :integer
  end
end
