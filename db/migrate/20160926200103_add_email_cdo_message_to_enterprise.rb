class AddEmailCdoMessageToEnterprise < ActiveRecord::Migration
  def change
    change_table :enterprises do |t|
      t.text :cdo_message_email, after: :cdo_message
    end
  end
end
