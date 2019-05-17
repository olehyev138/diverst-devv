class AddSponsorDescriptionToErgSetting < ActiveRecord::Migration[5.1]
  def change
  	add_column :groups, :sponsor_message, :text
  end
end
