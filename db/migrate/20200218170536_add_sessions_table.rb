class AddSessionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :legacy_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :legacy_sessions, :session_id, :unique => true
    add_index :legacy_sessions, :updated_at
  end
end
