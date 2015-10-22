class CreateEmployeesGroups < ActiveRecord::Migration
  def change
    create_table :employee_groups do |t|
      t.belongs_to :employee
      t.belongs_to :group
      t.timestamps
    end
  end
end
