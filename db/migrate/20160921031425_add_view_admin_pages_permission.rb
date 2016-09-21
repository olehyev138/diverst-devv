class AddViewAdminPagesPermission < ActiveRecord::Migration
  def change
    change_table :policy_groups do |t|
      t.boolean :admin_pages_view, default: false
    end
  end
end
