class AddDisableSponsorMessage < ActiveRecord::Migration[5.1]
  def change
  	add_column :enterprises, :disable_sponsor_message, :boolean, default: false
  end
end
