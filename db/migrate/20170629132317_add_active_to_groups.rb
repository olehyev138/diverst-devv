class AddActiveToGroups < ActiveRecord::Migration[5.1]
  def change
    change_table :groups do |t|
      t.boolean :active, default: true
    end
  end
end
