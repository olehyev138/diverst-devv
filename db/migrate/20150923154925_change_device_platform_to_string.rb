class ChangeDevicePlatformToString < ActiveRecord::Migration
  def change
    change_table :devices do |t|
      t.remove :platform
      t.string :platform
    end
  end
end
