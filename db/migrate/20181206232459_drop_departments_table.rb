class DropDepartmentsTable < ActiveRecord::Migration[5.1]
  def change
  	drop_table :departments
  end
end
