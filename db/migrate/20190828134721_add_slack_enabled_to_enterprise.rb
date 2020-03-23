class AddSlackEnabledToEnterprise < ActiveRecord::Migration[5.2]
  def change
    add_column :enterprises, :slack_enabled, :boolean, default: false
  end
end
