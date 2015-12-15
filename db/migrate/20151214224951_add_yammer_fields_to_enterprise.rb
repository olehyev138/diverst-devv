class AddYammerFieldsToEnterprise < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.boolean :yammer_import, default: false
      t.boolean :yammer_group_sync, default: false
    end
  end
end
