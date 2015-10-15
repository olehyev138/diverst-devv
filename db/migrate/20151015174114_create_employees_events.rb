class CreateEmployeesEvents < ActiveRecord::Migration
  def change
    create_table :employees_events do |t|
      t.belongs_to :employees
      t.belongs_to :events
    end
  end
end
