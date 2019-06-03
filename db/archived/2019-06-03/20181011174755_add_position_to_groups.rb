class AddPositionToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :position, :integer
  end
end
