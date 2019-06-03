class AddYammerGroupToGroup < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.string :yammer_group_link, after: :yammer_sync_users
    end
  end
end
