class RenameSetEmailAsGroupContactToGroupContact < ActiveRecord::Migration
  def change
  	rename_column :group_leaders, :set_email_as_group_contact, :group_contact
  end
end
