class CreateCampaignInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_invitations do |t|
      t.belongs_to :campaign
      t.belongs_to :user
      t.integer :response, default: 0

      t.timestamps null: false
    end
  end
end
