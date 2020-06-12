class CreateVideoParticipants < ActiveRecord::Migration
  def change
    create_table :video_participants do |t|
      t.datetime :timestamp
      t.string :identity
      t.integer :duration
      t.references :video_room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
