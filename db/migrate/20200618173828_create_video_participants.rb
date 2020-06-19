class CreateVideoParticipants < ActiveRecord::Migration[5.2]
  def change
    unless table_exists? :video_rooms
      create_table :video_participants do |t|
        t.datetime :timestamp
        t.string :identity
        t.integer :duration
        t.references :video_room, index: true, foreign_key: true

        t.timestamps null: false
      end
    end
  end
end
