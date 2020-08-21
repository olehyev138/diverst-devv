class RemoveCampaignIdFromUserRewardActions < ActiveRecord::Migration
  def change
    remove_column :user_reward_actions, :campaign_id, :integer
  end
end
