class AddYammerSyncToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.boolean :yammer_create_group
      t.boolean :yammer_group_created
      t.string :yammer_group_name
      t.boolean :yammer_sync_employees
    end
  end
end
