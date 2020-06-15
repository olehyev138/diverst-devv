class AddInitiativeReferenceToVideoRooms < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :video_rooms, :initiative_id
      add_reference :video_rooms, :initiative, index: true, foreign_key: true
    end
  end
end
