class DropEventAndEventRelatedTables < ActiveRecord::Migration
  def change
    drop_table :events
    drop_table :event_attendances
    drop_table :event_comments
    drop_table :event_fields
    drop_table :event_invitees
    drop_table :events_segments
  end
end
