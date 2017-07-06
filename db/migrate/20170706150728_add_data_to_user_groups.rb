class AddDataToUserGroups < ActiveRecord::Migration
  def change
    change_table :user_groups do |t|
      t.text :data
    end
  end
end
