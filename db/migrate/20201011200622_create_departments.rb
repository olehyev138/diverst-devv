class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless table_exists? :departments
      create_table :departments do |t|
        t.string :name
        t.references :enterprise, index: true, foreign_key: true

        t.timestamps null: false
      end
    end
  end
end
