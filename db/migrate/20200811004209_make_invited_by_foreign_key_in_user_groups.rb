class MakeInvitedByForeignKeyInUserGroups < ActiveRecord::Migration
  def change
    remove_column :user_groups, :invited_by, :string
    add_column :user_groups, :invited_by_id, :integer
  end
end
