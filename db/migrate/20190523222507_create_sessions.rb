class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string      :token
      t.datetime    :expires_at
      t.string      :device_type
      t.string      :device_name
      t.string      :device_version
      t.string      :operating_system
      t.string      :status
      t.references  :user

      t.timestamps
    end
  end
end
