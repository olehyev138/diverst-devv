class AddDefaultToPolicyGroups < ActiveRecord::Migration
  def change
    change_table :policy_groups do |t|
      t.boolean :default_for_enterprise, default: false
    end
  end
end
