class AddEventNameToVideoRooms < ActiveRecord::Migration
  def change
    add_column :video_rooms, :event_name, :string
  end
end
