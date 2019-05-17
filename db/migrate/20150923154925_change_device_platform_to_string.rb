class ChangeDevicePlatformToString < ActiveRecord::Migration[5.1]
  def change
    change_table :devices do |t|
      t.remove :platform
      t.string :platform
    end
  end
end
