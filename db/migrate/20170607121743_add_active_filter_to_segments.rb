class AddActiveFilterToSegments < ActiveRecord::Migration[5.1]
  def change
    change_table :segments do |t|
      t.string :active_users_filter
    end
  end
end
