class AddColumnToUserRewardActions < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :user_reward_actions, :user_group_id
      add_column :user_reward_actions, :user_group_id, :integer
    end
  end
end
