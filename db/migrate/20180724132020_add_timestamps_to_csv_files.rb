class AddTimestampsToCsvFiles < ActiveRecord::Migration
  def change
    change_table :csvfiles do |t|
      t.timestamps null: false
    end
  end
end
