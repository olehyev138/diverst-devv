class CreateDepartments < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists?('departments')
      drop_table :departments
      
      create_table :departments do |t|
        t.string :name
        t.references :enterprise, index: true, foreign_key: true

        t.timestamps null: false
      end
    end
  end
end
