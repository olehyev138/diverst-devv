class AddPositionTextFieldToGroupsTable < ActiveRecord::Migration[5.1]
  def change
  	add_column :groups, :sponsor_title, :string
  end
end
