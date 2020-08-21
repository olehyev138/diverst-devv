class AddSuggestedHireIdToUserRewardActions < ActiveRecord::Migration
  def change
    add_column :user_reward_actions, :suggested_hire_id, :integer
  end
end
