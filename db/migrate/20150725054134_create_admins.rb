class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :last_name

      t.belongs_to :enterprise

      t.timestamps null: false
    end
  end
end
