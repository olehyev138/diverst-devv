class AddCdoMessageToEnterprise < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.text :cdo_message
    end
  end
end
