class CreateCampaignInvitations < ActiveRecord::Migration
  def change
    create_table :campaign_invitations do |t|
      t.belongs_to :campaign
      t.belongs_to :employee
      t.integer :response

      t.timestamps null: false
    end
  end
end
