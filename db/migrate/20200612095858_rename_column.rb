class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :video_rooms, :type, :room_type
  end
end
