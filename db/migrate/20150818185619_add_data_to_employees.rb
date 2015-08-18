class AddDataToEmployees < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.text :data
    end
  end
end
