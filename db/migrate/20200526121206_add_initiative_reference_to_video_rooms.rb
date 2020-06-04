class AddInitiativeReferenceToVideoRooms < ActiveRecord::Migration
  def change
    add_reference :video_rooms, :initiative, index: true, foreign_key: true
  end
end
