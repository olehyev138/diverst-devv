class AddHomeMessageToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.text :home_message
    end
  end
end
