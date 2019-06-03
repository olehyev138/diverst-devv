class AddDataToUserGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :user_groups do |t|
      t.text :data
    end
  end
end
