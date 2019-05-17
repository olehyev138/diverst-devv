class AddAcceptedMembershipToUserGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :user_groups do |t|
      t.boolean :accepted_member, default: false
    end
  end
end
