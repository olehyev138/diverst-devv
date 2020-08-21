class AddCampaignIdToUserRewardActions < ActiveRecord::Migration
  def change
    add_column :user_reward_actions, :campaign_id, :integer
  end
end
