class CreateEventsSegments < ActiveRecord::Migration
  def change
    create_table :events_segments do |t|
      t.belongs_to :event
      t.belongs_to :segment
    end
  end
end
