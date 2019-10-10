class AddStatusToUserRewards < ActiveRecord::Migration
  def change
  	add_column :user_rewards, :status, :integer
  end
end
