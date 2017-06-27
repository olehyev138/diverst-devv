class AddStatusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :status, :integer, default: 0
  end
end
