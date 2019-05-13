class AddPositionTextFieldToGroupsTable < ActiveRecord::Migration
  def change
    add_column :groups, :sponsor_title, :string
  end
end
