class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :token
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
