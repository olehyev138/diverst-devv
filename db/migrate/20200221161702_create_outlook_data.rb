class CreateOutlookData < ActiveRecord::Migration
  def change
    create_table :outlook_data do |t|
      t.belongs_to :user
      t.text :encrypted_token_hash
      t.text :encrypted_token_hash_iv
      t.boolean :auto_add_event_to_calendar, default: true
      t.boolean :auto_update_calendar_event, default: true

      t.timestamps null: false
    end
  end
end
