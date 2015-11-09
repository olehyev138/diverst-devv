class CreateGraphs < ActiveRecord::Migration
  def change
    create_table :graphs do |t|
      t.belongs_to :enterprise
      t.belongs_to :field
      t.belongs_to :aggregation

      t.timestamps null: false
    end
  end
end
