class AddDepartmentIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :questions, :department_id
      add_column :questions, :department_id, :integer
    end
  end
end
