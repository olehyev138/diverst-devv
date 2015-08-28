class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.belongs_to :employee1
      t.belongs_to :employee2

      t.timestamps null: false
    end
  end
end
