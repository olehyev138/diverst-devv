class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.belongs_to :user
      t.text :data

      t.timestamps null: false
    end
  end
end
