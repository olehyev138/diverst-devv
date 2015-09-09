class CreateGroupRules < ActiveRecord::Migration
  def change
    create_table :group_rules do |t|
      t.belongs_to :group

      t.belongs_to :field
      t.integer :operator
      t.string :values

      t.timestamps null: false
    end
  end
end
