class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.integer :enterprise_id, null: false
      t.string  :name

      t.timestamps null: false
    end
  end
end
