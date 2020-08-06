class AddColumnsToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :invitation_sent_at, :datetime
    add_column :user_groups, :invitation_accepted_at, :datetime
    add_column :user_groups, :invited_by, :string
  end
end
