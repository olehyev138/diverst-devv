class AddLayoutIdToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.integer :layout_id, default: 0
    end
  end
end
