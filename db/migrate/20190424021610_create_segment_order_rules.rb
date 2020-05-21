class CreateSegmentOrderRules < ActiveRecord::Migration
  def change
    create_table :segment_order_rules do |t|
      t.belongs_to :segment, index: true
      t.timestamps null: false
      t.integer :operator, null: false
      t.integer :field, null: false
    end
  end
end
