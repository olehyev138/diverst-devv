class AddOptionToSetContactForGroup < ActiveRecord::Migration
  def change
  	add_column :group_leaders, :set_contact_email, :boolean, default: false
  end
end
