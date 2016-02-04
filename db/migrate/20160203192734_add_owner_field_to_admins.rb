class AddOwnerFieldToAdmins < ActiveRecord::Migration
  def change
    change_table :admins do |t|
      t.boolean :owner, default: false
    end
  end
end
