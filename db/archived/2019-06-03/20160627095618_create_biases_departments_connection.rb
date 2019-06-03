class CreateBiasesDepartmentsConnection < ActiveRecord::Migration[5.1]
  def change
    create_table :biases_from_departments do |t|
      t.integer :bias_id
      t.integer :department_id
    end

    create_table :biases_to_departments do |t|
      t.integer :bias_id
      t.integer :department_id
    end
  end
end
