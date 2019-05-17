class AddEmailStatusToCampaignInvitation < ActiveRecord::Migration[5.1]
  def change
    change_table :campaign_invitations do |t|
      t.boolean :email_sent, default: false
    end
  end
end
