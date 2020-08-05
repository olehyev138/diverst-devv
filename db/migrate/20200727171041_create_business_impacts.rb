class CreateBusinessImpacts < ActiveRecord::Migration
  def change
    create_table :business_impacts do |t|
      t.string :name
      t.references :enterprise, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
