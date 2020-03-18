class AddStatusToUserRewards < ActiveRecord::Migration[5.2]
  def change
  	add_column :user_rewards, :status, :integer
  end
end
