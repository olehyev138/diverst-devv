class AddYammerIdToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.integer :yammer_id
    end
  end
end
