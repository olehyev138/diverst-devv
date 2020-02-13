class AddSlackEnabledToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :slack_enabled, :boolean, default: false
  end
end
