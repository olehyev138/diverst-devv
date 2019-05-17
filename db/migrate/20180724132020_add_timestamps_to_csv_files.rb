class AddTimestampsToCsvFiles < ActiveRecord::Migration[5.1]
  def change
    change_table :csvfiles do |t|
      t.timestamps null: false
    end
  end
end
