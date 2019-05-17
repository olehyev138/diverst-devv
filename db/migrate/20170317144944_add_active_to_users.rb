class AddActiveToUsers < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.boolean :active, default: true
    end
  end
end
