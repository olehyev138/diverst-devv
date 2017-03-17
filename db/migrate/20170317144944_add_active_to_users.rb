class AddActiveToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :active, default: true
    end
  end
end
