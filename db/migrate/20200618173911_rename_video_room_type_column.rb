class RenameVideoRoomTypeColumn < ActiveRecord::Migration[5.2]
  def change
    unless table_exists? :video_rooms
      rename_column :video_rooms, :type, :room_type
    end
  end
end
