class AddGroupIdToCsvFile < ActiveRecord::Migration
  def change
    add_column  :csvfiles, :group_id,  :integer
  end
end
