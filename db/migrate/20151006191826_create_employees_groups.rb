class CreateEmployeesGroups < ActiveRecord::Migration
  def change
    create_table :employees_groups do |t|
      t.belongs_to :employee
      t.belongs_to :group
    end
  end
end
