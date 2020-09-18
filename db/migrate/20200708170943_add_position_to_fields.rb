class AddPositionToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :position, :integer
  end
end
