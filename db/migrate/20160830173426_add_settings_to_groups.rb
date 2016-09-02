class AddSettingsToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.string :pending_users
      t.string :members_visibility
      t.string :messages_visibility
    end
  end
end
