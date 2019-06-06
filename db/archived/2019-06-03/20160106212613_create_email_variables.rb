class CreateEmailVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :email_variables do |t|
      t.belongs_to :email
      t.string :key
      t.text :description
      t.boolean :required

      t.timestamps null: false
    end
  end
end
