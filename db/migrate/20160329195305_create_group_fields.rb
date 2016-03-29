class CreateGroupFields < ActiveRecord::Migration
  def change
    create_table :group_fields do |t|
      t.belongs_to :group
      t.belongs_to :field

      t.timestamps null: false
    end
  end
end