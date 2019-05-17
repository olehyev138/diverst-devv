class AddStatusToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :status, :integer, default: 0
  end
end
