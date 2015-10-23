class CreateMobileFields < ActiveRecord::Migration
  def change
    create_table :mobile_fields do |t|
      t.belongs_to :enterprise
      t.belongs_to :field
      t.integer :index # For ordering

      t.timestamps null: false
    end
  end
end
