class AddSlackWebhookToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :slack_webhook, :string
  end
end
