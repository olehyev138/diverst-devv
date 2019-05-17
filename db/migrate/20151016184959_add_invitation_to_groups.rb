class AddInvitationToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.boolean :send_invitations
    end
  end
end
