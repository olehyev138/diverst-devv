class CreateCampaignsGroups < ActiveRecord::Migration
  def change
    create_table :campaigns_groups do |t|
      t.belongs_to :campaign
      t.belongs_to :group
    end
  end
end
