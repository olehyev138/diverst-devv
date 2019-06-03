class AddSponsorDescriptionToErgSetting < ActiveRecord::Migration
  def change
    add_column :groups, :sponsor_message, :text
  end
end
