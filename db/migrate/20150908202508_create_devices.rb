class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :platform
      t.string :token
      t.belongs_to :employee

      t.timestamps null: false
    end
  end
end
