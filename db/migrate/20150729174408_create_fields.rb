class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :type
      t.string :title
      t.belongs_to :enterprise

      t.timestamps null: false
    end
  end
end
