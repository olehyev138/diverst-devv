class AddYammerIdToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.integer :yammer_id
    end
  end
end
