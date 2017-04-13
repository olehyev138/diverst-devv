class CreateRewardActions < ActiveRecord::Migration
  def change
    create_table :reward_actions do |t|
      t.string :label, null: false
      t.integer :points
      t.string :key, null: false
      t.references :enterprise, index: true, foreign_key: true

      t.timestamps
    end
  end
end
