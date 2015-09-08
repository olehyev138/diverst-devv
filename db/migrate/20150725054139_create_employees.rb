class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.text :data
      t.string :auth_source
      t.belongs_to :enterprise

      t.timestamps null: false
    end
  end
end
