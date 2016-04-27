class CreateEventAttendances < ActiveRecord::Migration
  def change
    create_table :event_attendances do |t|
      t.belongs_to :event
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
