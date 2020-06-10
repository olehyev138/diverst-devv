class CreateVideoRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :video_rooms do |t|
      t.string :sid
      t.string :type
      t.string :name
      t.string :status
      t.integer :duration
      t.datetime :start_date
      t.datetime :end_date
      t.integer :participants
      t.references :enterprise, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
