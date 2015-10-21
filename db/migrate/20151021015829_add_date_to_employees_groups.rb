class AddDateToEmployeesGroups < ActiveRecord::Migration
  def change
    change_table :employees_groups do |t|
      t.timestamp
    end
  end
end
