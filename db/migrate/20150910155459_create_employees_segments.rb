class CreateEmployeesSegments < ActiveRecord::Migration
  def change
    create_table :employees_segments do |t|
      t.belongs_to :employee
      t.belongs_to :segment
    end
  end
end
