class DropLegacySessions < ActiveRecord::Migration
  def change
    remove_index :legacy_sessions, name: 'index_legacy_sessions_on_session_id', unique: true
    remove_index :legacy_sessions, name: 'index_legacy_sessions_on_updated_at'

    drop_table :legacy_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end
  end
end
