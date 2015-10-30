class CreateCampaignsSegments < ActiveRecord::Migration
  def change
    create_table :campaigns_segments do |t|
      t.belongs_to :campaign
      t.belongs_to :segment
    end
  end
end
