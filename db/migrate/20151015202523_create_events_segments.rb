class CreateEventsSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :events_segments do |t|
      t.belongs_to :event
      t.belongs_to :segment
    end
  end
end
