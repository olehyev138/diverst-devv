class CreateGroupLeaders < ActiveRecord::Migration
  def change
    create_table :group_leaders do |t|
      t.integer :group_id
      t.integer :user_id

      t.string :position_name

      t.timestamps null: false
    end
  end
end
