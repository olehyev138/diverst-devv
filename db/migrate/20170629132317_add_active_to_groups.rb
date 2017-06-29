class AddActiveToGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.boolean :active, default: true
    end
  end
end
