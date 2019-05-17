class AddEnableRewardsToEnterprises < ActiveRecord::Migration[5.1]
  def change
    add_column :enterprises, :enable_rewards, :boolean, :default => false
  end
end
