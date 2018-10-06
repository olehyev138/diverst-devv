class AddHomeMessageToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.text :home_message
    end
  end
end
