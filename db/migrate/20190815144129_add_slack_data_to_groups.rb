class AddSlackDataToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :slack_auth_data, :text
  end
end
