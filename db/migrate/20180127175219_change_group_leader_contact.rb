class ChangeGroupLeaderContact < ActiveRecord::Migration
  def change
    rename_column :group_leaders, :set_email_as_group_contact, :default_group_contact
  end
end
