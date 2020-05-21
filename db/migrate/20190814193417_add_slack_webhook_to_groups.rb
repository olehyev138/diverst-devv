class AddSlackWebhookToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :slack_webhook, :string
  end
end
