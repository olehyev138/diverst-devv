class AddInvitationToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.boolean :send_invitations
    end
  end
end
