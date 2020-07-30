class AddDepartmentIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :department_id, :integer
  end
end
