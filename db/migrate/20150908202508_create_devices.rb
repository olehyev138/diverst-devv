class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.integer :platform
      t.string :token
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
