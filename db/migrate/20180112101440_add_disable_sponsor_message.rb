class AddDisableSponsorMessage < ActiveRecord::Migration
  def change
    add_column :enterprises, :disable_sponsor_message, :boolean, default: false
  end
end
