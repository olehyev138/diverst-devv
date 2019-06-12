class AddOptionToSetContactForGroup < ActiveRecord::Migration
  def change
    add_column :group_leaders, :set_email_as_group_contact, :boolean, default: false
  end
end
