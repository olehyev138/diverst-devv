class AddEnableRewardsToEnterprises < ActiveRecord::Migration
  def change
    add_column :enterprises, :enable_rewards, :boolean, :default => false
  end
end
