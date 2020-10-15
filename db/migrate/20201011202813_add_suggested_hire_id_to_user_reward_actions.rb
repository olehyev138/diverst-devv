class AddSuggestedHireIdToUserRewardActions < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :user_reward_actions, :suggested_hire_id
      add_column :user_reward_actions, :suggested_hire_id, :integer
    end
  end
end
