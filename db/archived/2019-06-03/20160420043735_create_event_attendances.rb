class CreateEventAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :event_attendances do |t|
      t.belongs_to :event
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
