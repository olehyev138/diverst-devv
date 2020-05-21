class AddSlackDataToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :slack_auth_data, :text
  end
end
