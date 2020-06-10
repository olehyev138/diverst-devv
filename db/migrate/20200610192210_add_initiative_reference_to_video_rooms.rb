class AddInitiativeReferenceToVideoRooms < ActiveRecord::Migration[5.2]
  def change
    add_reference :video_rooms, :initiative, index: true, foreign_key: true
  end
end
