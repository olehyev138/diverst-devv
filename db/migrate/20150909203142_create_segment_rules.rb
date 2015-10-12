class CreateSegmentRules < ActiveRecord::Migration
  def change
    create_table :segment_rules do |t|
      t.belongs_to :segment

      t.belongs_to :field
      t.integer :operator
      t.string :values

      t.timestamps null: false
    end
  end
end
