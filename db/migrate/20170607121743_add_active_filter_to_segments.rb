class AddActiveFilterToSegments < ActiveRecord::Migration
  def change
    change_table :segments do |t|
      t.string :active_users_filter
    end
  end
end
