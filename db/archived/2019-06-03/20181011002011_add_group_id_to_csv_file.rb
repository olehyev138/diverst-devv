class AddGroupIdToCsvFile < ActiveRecord::Migration[5.1]
  def change
    add_column  :csvfiles, :group_id,  :integer
  end
end
