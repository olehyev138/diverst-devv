class AddViewLogsToPolicyGroups < ActiveRecord::Migration
  def change
    change_table :policy_groups do |t|
      t.boolean :logs_view, default: false
    end
  end
end
