class CreateGroupUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :group_updates do |t|
      t.text :data
      t.text :comments

      t.belongs_to :owner
      t.belongs_to :group

      t.timestamps null: false
    end
  end
end
