class AddCdoDetailsToEnterprise < ActiveRecord::Migration[5.1]
  def change
    change_table :enterprises do |t|
      t.string :cdo_name
      t.string :cdo_title
      t.attachment :cdo_picture
    end
  end
end
