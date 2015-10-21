class RenameEmployeesGroups < ActiveRecord::Migration
  def change
    rename_table :employees_groups, :employee_groups
  end
end
