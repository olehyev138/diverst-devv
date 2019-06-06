class AddViewAdminPagesPermission < ActiveRecord::Migration[5.1]
  def change
    change_table :policy_groups do |t|
      t.boolean :admin_pages_view, default: false
    end
  end
end
